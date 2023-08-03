# qreacto.lua 
This is the main script that runs when the shortcode is encountered.

## Script overview

It defines various helper functions, they are documented in the script.

These functions handle the process of reading files, injecting scripts, ensuring dependencies, and more.

The main entry point of the filter is executed when the filter encounters a react shortcode in the Markdown file.

The react function first checks if the output format is HTML with JavaScript (html:js), which indicates that it should include React components in the document. If the format is not HTML with JavaScript, it returns pandoc.Null() to exclude the react shortcode from the output.

If the output format is HTML with JavaScript, it proceeds with the following steps, It:

1. Ensures the necessary React, ReactDOM, and Babel dependencies are included in the document.

2. Scans the components folder for supporting files (JavaScript and CSS) and injects their content into the document using the raw_add_script function.

3. Reads the content of the specified React component file and modifies it to handle local imports recursively using the `modify_with_imports` function.

4. Generates a unique componentId to identify the div element where the React component will be rendered.

5. Adds the React component to the document by using ReactDOM.render, injecting the component into the div element with the generated componentId.

6. It creates a div element with the generated componentId to be included in the document as a placeholder for the React component.

The modified content with the React components and supporting resources is then included in the final output.