/**
 * Basic fetch service example
 * Notice how this file is a typescript file, but the rest of the project is javascript
 */
function fetchData() {  
    return fetch(`https://dummyjson.com/products?limit=10`)
      .then(response => {
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