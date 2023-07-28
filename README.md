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

If you want to use **typescript**, you can add the following attribute

``` bash
{{< react MyComponent type="typescript" >}}
```

Dont forget to save your file with the `.tsx` extension

Note that the name of the component and the name of the file must match in order for the filter to pull the component in. So the component should be saved at `components/MyComponent.jsx`

or for typescript

`components/MyComponent.tsx`

## Adding imports

We can use esms and CDNs to deliver imports whilst in the browsers. Here's is an example of using imports with esm.run

```
import * as math from 'https://esm.run/math';
		

function UseEffect() {
  const [count, setCount] = React.useState(0);

  const a = 5;
  const b = 10;

  // Using the 'add' function from the Math module
  const sum = math.default.add(a, b);
  const handleClick = () => {
    setCount((prevCount) => prevCount + 1);
  };

  return (
    <div>
      <h1>Count: {count}</h1>
      <button onClick={handleClick}>Increment</button>
      <p>Math Sum {sum}</p>
    </div>
  );
}
```

The modules are being imported and run in the browser, it is not being bundled. In order to leverage third party packages, make sure it is available as an es6 module [here](https://www.jsdelivr.com/esm) or [here](https://esm.run)

Then import it and use accordingly, 

