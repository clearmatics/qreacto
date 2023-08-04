
import fetchData from "./fetchingservice";
import List from "./List";
/**
 * An example of react component with a fetch service imported
 * @returns 
 */
function Products() {
    const [data, setData] = React.useState([]);

    return (
      <div>
        <List />
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