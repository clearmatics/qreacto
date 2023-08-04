/**
 * Basic fetch service example
 */
function fetchData() {
  console.log(2)
    return fetch(`https://dummyjson.com/products/`)
      .then(response => {
        
        console.log('got response', response)
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })     
      .catch(error => {
        console.error('Error fetching data:', error);
      });
  }

  export default fetchData;