# React components in Quarto

Run standalone React components in your Quarto project!

## Installation

To install this extension in your current directory (or into the Quarto project that you're currently working in), use the following command:

``` bash
quarto add clearmatics/qreacto
```

## Running a React component

To run a React component, first, create a folder called `components/` in the root of the project.
Then create your component in a .jsx or .tsx file. For example:


``` javascript
/**
 * An example of React with fetch
 * @returns 
 */
function FetchComponent() {
    // ...
}

```

Next, add the shortcode into the .qmd file where you want the component to be displayed:

``` bash
{{< react FetchComponent >}}
```

If you are using TypeScript, the extension will automatically detect the file type and use the correct Babel preset. 

However, you can also be explicit:

``` bash
{{< react FetchComponent type="typescript" >}}
```

Ensure that the name of the component and the name of the file match for the filter to work correctly. **It is also case sensitive.**

For example, if the component is named `FetchComponent`, save it in the file `components/FetchComponent.jsx` for JavaScript or `components/FetchComponent.tsx` for TypeScript.

## Adding thirdparty imports

You can leverage ES modules and Content Delivery Networks (CDNs) to import third-party packages directly into your react component, without the need for local installations or bundling. CDNs offer several benefits for importing dependencies.

``` javascript
import * as math from 'https://esm.run/math';

function MyComponent() {
    // ... 
}

```

Make sure the third-party package is available as an ES6 module, either from jsdelivr or esm.run (or any other ES6 module CDN). Import and use the package accordingly.

## Adding local imports

You can also import components from the same folder:

``` javascript
import ButtonExample from "./ButtonExample";

function FetchComponent() {
    // ... 
}
```

Currently, components can only be imported from the same folder. If you have a component in a subfolder, you will need to move it to the same folder as the component you are importing it into.

**Note:** The files should use the same extension as the component you are importing into. For instance, if you are importing into a `.tsx` file, the files you are importing should also be `.tsx` files.

## Supporting files and scripts

JavaScript and CSS files are automatically included in the page. If your component requires a CSS file, include it in the same folder as the component, and it will be included in the page.

Supported files are currently pulled from the `components` folder. The accepted extensions include `.css`, `.js`, and `.ts`.

You can modify the `reacto.lua` script to change where it looks for resources:

``` lua
local component_folder = 'components' -- This is where the script looks for react components
local resources_folder = 'components' -- This is where the script looks for supporting files 
local react_component_extensions = { '.jsx', '.tsx' } -- These are the accepted react extensions
local supporting_extensions = { ['.css'] = true, ['.js'] = true, ['.ts'] = true } -- These are the accepted supporting extensions.
```

## Gotchas

- Avoid including imports of React in your component, as Babel will already provide this on the window.


## Known issues and tasks still to do
- [ ] Arrow functions are not currently supported. The Babel plugin `transform-arrow-functions` conflicts with the Babel TypeScript preset. This is currently being investigated.
- [ ] Allow deep imports
- [x] infer the file type (and then set the preset) during the lua filter rather than having to specify it in the shortcode (eg don't need to specify `type="typescript"` in the shortcode)
- [ ] Named imports are not currently supported `import { NamedButton } from './Button';` will not work but `import Button from './Button'` will.
- [ ] Typescript types and type casting not working as expected. for example `as unknown as MyType` will throw

## Getting started with development

If you would like to contribute, there's a [readme](_extension/qreacto/README.md) in the `_extension/qreacto` folder that explains the codeflow for the qreacto.lua script, its a great place to start.

To develop the extension, you need to run it in a Quarto project. The quickest way to set up a project is by running the following command in the root directory:

``` bash
quarto create project
```

This command will set up a project that allows you to test the functionality.

React components are to be located in the components/ folder at the root of the project. Some basic examples are already provided.

The script `qreacto.lua` is the main script that is run when the shortcode is encountered. It is located in the `_extension/qreacto` folder.

## Contributing
We welcome contributions from the community to help improve and enhance this project. Whether you want to report a bug, suggest a new feature, or submit code changes, your efforts are highly appreciated.

## Reporting Issues
If you encounter any bugs, glitches, or unexpected behaviour while using this project, please open an issue on the GitHub repository. When reporting issues, please provide as much information as possible, including the steps to reproduce the problem and details about your environment.

## Suggesting Enhancements
If you have ideas for new features or improvements, feel free to create an enhancement request in the GitHub repository. We value creative ideas that can add value to the project and its users.

## Code Contributions
We encourage contributions from developers of all skill levels. If you want to contribute code changes, please follow our [Contributing](CONTRIBUTING.md) guidelines.

## Code of Conduct
Please note that we adhere to a Code of Conduct in this project. All contributors are expected to follow these guidelines to ensure a friendly, inclusive, and respectful environment for everyone.

By contributing to this project, you agree to abide by the Code of Conduct, which can be found in the repository's [Code of Conduct](CODE_OF_CONDUCT.md) file.

## Getting Help
If you need help or have questions about contributing, feel free to reach out to us by creating an issue or joining our community channels. We are more than happy to assist you throughout the process.

Thank you for your interest in contributing to this project! Your contributions play a vital role in making this project better for the community. We look forward to your involvement and collaboration. Happy contributing!
