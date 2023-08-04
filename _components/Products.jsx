
import fetchData from "./fetchingservice";
import List from "./List";
import './style.css';
/**
 * An example of react component with a fetch service imported
 * @returns 
 */
function Products() {
    const [data, setData] = React.useState([]);
    React.useEffect(() => {      
      fetchData().then((data) => setData(data));
    }, [])
    
    return (
      <div>
        <h1>Products</h1>
        <div className="wrapper">
          {data.products && data.products.length > 0 && (data.products.map((product) => <List key={product.id} product={product} />))}
        </div>
      </div>
    );
  }
  export default Products