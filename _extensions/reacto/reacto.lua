local component_folder = 'components'

--todo use a debugging flag stored in _quarto.yaml to handle logging
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

-- includes reactDOM.render into the document, with provided component name and element id
-- inject the component into the script tag
local function add_react_element(ComponentName, elementId, extension)
    print(ComponentName .. " > " .. elementId)
    local path = quarto.project.directory .. '/' .. component_folder .. '/' .. ComponentName .. '.' .. extension

    -- default presets env-plus is needed for imports to work with esms
    -- react is required because... React
    local presets = 'env-plus,react'

    -- check if extension is equal to typescript
    if extension == 'tsx' then
        presets = presets .. ',typescript'
    end
    quarto.doc.include_text('after-body',
        '<script type="text/babel" data-type="module" data-presets="' .. presets .. '">' ..
        '' .. read_file_to_string(path, extension) ..
        'ReactDOM.render(' ..
        ' <React.StrictMode> ' ..
        '   <' .. ComponentName .. '/> ' ..
        ' </React.StrictMode>, ' ..
        ' document.getElementById("' .. elementId .. '") ' ..
        ');' ..
        '</script>'
    )
end

-- given a component as a string, look for local imports
-- inject the contents of that local import component
-- return the content, modified to include the imports
local function modify_with_imports(content, extension)
    local imported_content = {}
    local modified_content = content

    -- look for import keyword
    local import = string.find(content, "import")

    if import then
        for line in content:gmatch("[^\r\n]+") do
            -- get the import variable and the location of the file
            -- local importVar, location = line:match("^%s*import%s+([%w_]+)%s+from%s+['\"]([^'\"]+)['\"]%s*$")
            local importVar, location = line:match("^%s*import%s+([%w_]+)%s+from%s+['\"]([^'\"]+)['\"].*$")

            -- add a local import candidate if the import isn't making a CDN http request
            if importVar and location and not string.find(location, 'http') then
                -- normalize location as it could be './'
                local normalizedLocation = string.gsub(location, './', '')

                -- get the path of the file
                local path = quarto.project.directory ..
                    '/' .. component_folder .. '/' .. normalizedLocation .. '.' .. extension
                print('local import found: ' .. path)

                -- recursive call to get the content of the import
                local importContent = read_file_to_string(path, extension)

                -- push results to array (as there might be more then one import to handle)
                table.insert(imported_content, importContent)

                -- remove the import from the content to prevent some browsers trying to fetch local files
                modified_content = string.gsub(modified_content, line, '')
            end
        end
    end

    -- concat the array of import content with the modified content (the content without the imports)
    -- return it
    return table.concat(imported_content, "\n") .. modified_content
end


-- Function to read the contents of a file and store it in a string
function read_file_to_string(filename, extension)
    local file = io.open(filename, "r") -- Open the file in read mode
    if not file then
        print("Error: File not found or unable to open.")
        return nil
    end

    local content = file:read("*all") -- Read the entire content of the file
    file:close()                      -- Close the file before handling imports (as it can recurse and we -may- end up with multiple open file streams )

    return modify_with_imports(content, extension)
end

-- check if string is empty
local function is_empty(s)
    return s == nil or s == ''
end

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

return {
    ["react"] = function(args, kwargs)
        if quarto.doc.is_format("html:js") then
            ensure_react()
            ensure_react_dom()
            ensure_babel_transpiler()
            ensure_imports_babel_preset()

            local componentname = pandoc.utils.stringify(args[1])

            if is_empty(componentname) then
                error("react: component name is required")
            end

            local componentId = 'react-' .. componentname .. '-' .. randomString(8)
            local componentType = pandoc.utils.stringify(kwargs["type"])
            local fileType = 'jsx'

            -- check it is not empty and it is a typescript component
            if not is_empty(componentType) and componentType == 'typescript' then
                fileType = 'tsx'
            end

            -- Add the React injection
            add_react_element(componentname, componentId, fileType)

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
