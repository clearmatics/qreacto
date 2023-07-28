# React components in Quarto

Run standalone React components

## Getting started

For the purposes of development, the extension needs to be run in a quarto project, the quickest way to do this is to run the following in the root directory

``` bash
quarto create-project
```

This will setup a project that we can use temporarily to test out functionality.

Components will be searched for in the `components/` folder in the root of the project, there are some basic examples already available.

## Running a React component

First create your react component


``` javascript
/**
 * An example of react with fetch
 * @returns 
 */
function FetchComponent() {
    const [data, setData] = React.useState([]);
  
    // Function to fetch data from the endpoint
    function fetchData() {
      fetch(`https://dummyjson.com/products/${data.length + 1}`)
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(data => {
          // Update the state with the fetched data
          setData(previous => [...previous, ...[data]]);
        })
        .catch(error => {
          console.error('Error fetching data:', error);
        });
    }
  
    return (
      <div>
        <button onClick={fetchData}>Fetch Data</button>
        <div>
          {data ? (
            <pre>{JSON.stringify(data, null, 2)}</pre>
          ) : (
            <p>No data fetched yet. Click the button to fetch data.</p>
          )}
        </div>
      </div>
    );
  }
```

Next add the shortcode into the `.qmd` file you want the component to show in.

``` bash
{{< react FetchComponent >}}
```

If you want to use **typescript**, you can add the following attribute

``` bash
{{< react FetchComponent type="typescript" >}}
```

Dont forget to save your file with the `.tsx` extension

Note that the name of the component and the name of the file must match in order for the filter to pull the component in. So the component should be saved at `components/FetchComponent.jsx`

or for typescript

`components/FetchComponent.tsx`

## Adding thirdparty imports

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

The modules are being imported and run in the browser, it is not being bundled. In order to leverage third party packages, make sure it is available as an es6 module [here](https://www.jsdelivr.com/esm) or [here](https://esm.run) (or any other es6 module CDN)

Then import it and use accordingly, 

## Adding local imports

You can import components from the same folder, for example

``` javascript
import ButtonExample from "./ButtonExample";
/**
 * An example of react with fetch
 * @returns 
 */
function FetchComponent() {
    const [data, setData] = React.useState([]);
  
    // Function to fetch data from the endpoint
    function fetchData() {
      fetch(`https://d3sk8vqz7pzy2a.cloudfront.net/on_chain_totals.json`)
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(data => {
          // Update the state with the fetched data
          setData(previous => [...previous, ...[data]]);
        })
        .catch(error => {
          console.error('Error fetching data:', error);
        });
    }
  
    return (
      <div>
        <ButtonExample />
        <button onClick={fetchData}>Fetch Data</button>
        <div>
          {data ? (
            <pre>{JSON.stringify(data, null, 2)}</pre>
          ) : (
            <p>No data fetched yet. Click the button to fetch data.</p>
          )}
        </div>
      </div>
    );
  }
```

Currently, components can only be imported from the same folder, so if you have a component in a subfolder, you will need to move it to the same folder as the component you are importing it into.


**Note** The files should all use the same extension as the component you are importing into. So if you are importing into a `.tsx` file, the files you are importing should also be `.tsx` files.

## Gotchas

- Don't include imports of React in your component, Babel will already provide this on the window.

## Known issues and tasks still to do
- Arrow functions are not currently supported. The babel plugin `transform-arrow-functions` is conflicting with the babel typescript preset. This is being investigated.
- Allow deep imports
- Allow imports of different extensions