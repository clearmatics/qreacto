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

-- Change babel presets to use imports rather than require (es6)
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
    print(ComponentName .. " >>>> " .. elementId)
    local path = quarto.project.directory .. '/components/' .. ComponentName .. '.' .. extension

    -- default presets env-plus is needed for imports to work in es6 mode
    -- react is required because... React
    local presets = 'env-plus,react'

    -- check if extension is equal to typescript
    if extension == 'tsx' then
        presets = presets .. ',typescript'
    end
    quarto.doc.include_text('after-body',
        '<script type="text/babel" data-type="module" data-presets="' .. presets .. '">' ..
        '' .. read_file_to_string(path) ..
        'ReactDOM.render(' ..
        ' <React.StrictMode> ' ..
        '   <' .. ComponentName .. '/> ' ..
        ' </React.StrictMode>, ' ..
        ' document.getElementById("' .. elementId .. '") ' ..
        ');' ..
        '</script>'
    )
end


-- Function to read the contents of a file and store it in a string
function read_file_to_string(filename)
    local file = io.open(filename, "r") -- Open the file in read mode
    if not file then
        print("Error: File not found or unable to open.")
        return nil
    end

    local content = file:read("*all") -- Read the entire content of the file
    file:close()                      -- Close the file
    return content
end

-- check if string is empty
local function is_empty(s)
    return s == nil or s == ''
end

-- Function to generate a random string of given length
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
        print("React component found")
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
