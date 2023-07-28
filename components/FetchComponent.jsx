import ButtonExample from "./ButtonExample";
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