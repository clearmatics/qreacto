# React components in Quarto

Run standalone React components

## Getting started

For the purposes of development, the extension needs to be run in a quarto project, the quickest way to do this is to run the following in the root directory

``` bash
quarto create-project
```

This will setup a project that we can use temporarily to test out functionality.

Components will be searched for in the `components/` folder in the root of the project, there are some basic examples already available.

**Note** Currently only `.jsx` files are supported.

## Running a React component

First create your react component


``` javascript
function MyComponent() {
  const [count, setCount] = React.useState(0);

  const handleClick = () => {
    setCount((prevCount) => prevCount + 1);
  };

  return (
    <div>
      <h1>Count: {count}</h1>
      <button onClick={handleClick}>Increment</button>
    </div>
  );
}
```

Next add the shortcode into the `.qmd` file you want the component to show in.

``` bash
{{< react MyComponent >}}
```

Note that the name of the component and the name of the file must match in order for the filter to pull the component in. So the component should be saved at `components/MyComponent.jsx`


