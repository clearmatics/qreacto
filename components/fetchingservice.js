/**
 * Basic fetch service example
 */
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

  export default fetchData;