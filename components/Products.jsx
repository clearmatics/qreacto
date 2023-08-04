
import fetchData from "./fetchingservice";

/**
 * An example of react with fetch
 * @returns 
 */
function Products() {
    const [data, setData] = React.useState([]);

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
  export default Products