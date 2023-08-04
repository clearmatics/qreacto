local component_folder = '_components'
local resources_folder = '_components'
local react_component_extensions = { '.jsx', '.tsx', '.js', '.ts' }
local styles_to_import = {}

--[[
 ============================================================================
 Add react dependencies:
 react, babel, transpiler and react-dom
============================================================================
]]

-- include react dependencies
local function ensure_react()
    quarto.doc.add_html_dependency({
        name = 'react',
        version = '17.0.2',
        scripts = { "react.min.js" }
    })
end

-- include react dom dependencies
local function ensure_react_dom()
    quarto.doc.add_html_dependency({
        name = 'react-dom',
        version = '17.0.2',
        scripts = { "react-dom.min.js" }
    })
end

-- include babel transpiler (standalone)
local function ensure_babel_transpiler()
    quarto.doc.add_html_dependency({
        name = 'babel',
        version = '6.26.0',
        scripts = { "babel.min.js" }
    })
end

-- Change babel presets to use imports rather than require (esm)
local function ensure_imports_babel_preset()
    quarto.doc.add_html_dependency({
        name = 'babel-presets',
        version = '1.0.0',
        scripts = { "babel-presets.js" }
    })
end

--[[
============================================================================
 Helper functions:
 Handle loading of files, reading of files, and injecting of scripts
============================================================================
]]

-- Function to generate a random string of given length
-- we use this to asign a unique id to the react component and the div to inject the component into
local function randomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        str = str .. string.sub(chars, randomIndex, randomIndex)
    end
    return str
end

-- check if string is empty
local function is_empty(s)
    return s == nil or s == ''
end

-- returns the full file path if it exists
local function tryLoadFile(filename, extensions)
    for _, ext in ipairs(extensions) do
        local fullFilename = filename .. ext
        local file = io.open(fullFilename, "r")
        print('trying (case-sensitive): ' .. fullFilename)
        if file then
            file:close()
            return fullFilename
        end
    end

    return nil -- File not found with any of the extensions
end

-- given content and a type, add it to the document
local function include_text_in_document(content, type)
    -- if its js add it to the body
    if type == '.js' then
        quarto.doc.include_text('after-body', '<script type="text/javascript">' .. content .. '</script>')
    end

    -- if its css add it to the head
    if type == '.css' then
        quarto.doc.include_text('in-header', '<style>' .. content .. '</style>')
    end

    -- if its typescript babel transpile it
    if type == '.ts' then
        quarto.doc.include_text('after-body',
            '<script type="text/babel" data-type="module" data-presets="env-plus,typescript">' ..
            '' .. content ..
            '</script>'
        )
    end
end

-- Read the contents of a file and return it as a string
function read_file_to_string(filename)
    local file = io.open(filename, "r") -- Open the file in read mode
    if not file then
        print("Error: File not found or unable to open.")
        return nil
    end

    local content = file:read("*all") -- Read the entire content of the file
    file:close()                      -- Close the file before handling imports (as it can recurse and we -may- end up with multiple open file streams )
    return content
end

--[[
============================================================================
 Content manipulation and react component injection:
 Handle imports, exports, injecting nested dependencies, stylesheets
 and injecting the component
============================================================================
]]

-- look for local imports
-- inject the contents of that local import component (js, ts, jsx or tsx)
-- return the content, modified to include the imports
local function modify_with_imports(content)
    local imported_content = {}
    local modified_content = content

    -- look for import keyword
    local import = string.find(content, "import")

    if import then
        for line in content:gmatch("[^\r\n]+") do
            -- check for css imports
            local csslocation = line:match("^%s*import%s+['\"]([^'\"]+%.css)['\"].*$")
            if csslocation then
                -- normalize location as it could be './'
                local normalizedCssLocation = string.gsub(csslocation, './', '')

                -- get the path of the file
                local cssPath = quarto.project.directory .. '/' .. resources_folder .. '/' .. normalizedCssLocation

                print('local stylesheet found: ' .. cssPath)
                -- add the css file to the list of styles to import
                table.insert(styles_to_import, csslocation)
                -- remove the import from the content to prevent some browsers trying to fetch local files
                modified_content = string.gsub(modified_content, line, '')
            end

            -- get the import variable and the location of the file
            local importVar, location = line:match("^%s*import%s+([%w_]+)%s+from%s+['\"]([^'\"]+)['\"].*$")

            -- add a local import candidate if the import isn't making a CDN http request
            if importVar and location and not string.find(location, 'http') then
                -- normalize location as it could be './'
                local normalizedLocation = string.gsub(location, './', '')

                -- get the path of the file
                local path = quarto.project.directory .. '/' .. component_folder .. '/' .. normalizedLocation

                -- check if the location is a css file by checking if the last part of the import is ".css"

                -- check for nested react components
                local scriptFile = tryLoadFile(path, react_component_extensions)

                -- only import if jsx or tsx file exists
                if scriptFile then
                    print('local import found: ' .. path)

                    -- recursive call to get the content of the import
                    local importContent = modify_with_imports(read_file_to_string(scriptFile))

                    -- push results to array (as there might be more then one import to handle)
                    table.insert(imported_content, importContent)

                    -- remove the import from the content to prevent some browsers trying to fetch local files
                    modified_content = string.gsub(modified_content, line, '')
                else
                    error('local import not found: ' .. path)
                end
            end
        end
    end

    -- find line with export default and remove the entire line
    modified_content = string.gsub(modified_content, "export default[^\r\n]*\r?\n?", '')

    -- find line with export and remove it
    local export = string.find(modified_content, "export")
    if export then
        modified_content = string.gsub(modified_content, "export", '')
    end

    -- concat the array of import content with the modified content (the content without the imports)
    -- return it
    return table.concat(imported_content, "\n") .. modified_content
end

-- includes reactDOM.render into the document, with provided component name and element id
-- inject the component into the script tag
local function add_react_element(ComponentName, elementId)
    print(ComponentName .. " > " .. elementId)
    local path = quarto.project.directory .. '/' .. component_folder .. '/' .. ComponentName

    local foundFile = tryLoadFile(path, react_component_extensions)
    -- default presets env-plus is needed for imports to work with esms
    -- react is required because... React
    local presets = 'env-plus,react,typescript'

    if not foundFile then
        error("react: component not found: " .. path)
    end
    local content = read_file_to_string(foundFile)
    quarto.doc.include_text('after-body',
        '<script type="text/babel" data-type="module" data-presets="' .. presets .. '">' ..
        '' .. modify_with_imports(content) ..
        'ReactDOM.render(' ..
        ' <React.StrictMode> ' ..
        '   <' .. ComponentName .. '/> ' ..
        ' </React.StrictMode>, ' ..
        ' document.getElementById("' .. elementId .. '") ' ..
        ');' ..
        '</script>'
    )
end

-- add css files to the document
local function inject_imported_stylesheets()
    local path = quarto.project.directory .. '/' .. resources_folder

    -- loop over the styles_to_import array
    for _, filename in ipairs(styles_to_import) do
        print('injecting stylesheet: ' .. filename)
        local content = read_file_to_string(path .. '/' .. filename)
        return include_text_in_document(content, '.css')
    end
end

--[[
============================================================================
Script entry point
============================================================================
]]
return {
    ["react"] = function(args, kwargs)
        if quarto.doc.is_format("html:js") then
            -- add dependencies for react
            ensure_react()
            ensure_react_dom()
            ensure_babel_transpiler()
            ensure_imports_babel_preset()

            -- add local style sheets



            local componentname = pandoc.utils.stringify(args[1])
            if is_empty(componentname) then
                error("react: component name is required")
            end

            local componentId = 'react-' .. componentname .. '-' .. randomString(8)

            -- Add the React injection
            add_react_element(componentname, componentId)

            -- A list of css files to import will have been created when the component was injected
            inject_imported_stylesheets()

            -- Create the div element to place the component in
            return pandoc.RawInline(
                'html',
                '<div id="' .. componentId .. '"></div>'
            )
        else
            return pandoc.Null()
        end
    end
}
