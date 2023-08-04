import './style.css';
/**
 * An example of react with fetch
 * @param {Object} product - The product object with the specified structure.
 * @returns {JSX.Element} - The rendered JSX for the product details.
 */
function List({ product }) {    
    if(!product) return null
    return (
      <div className='item'>
        <h2>{product.title}</h2>
        <p>{product.description}</p>
        <p>Price: ${product.price}</p>
        <p>Discount Percentage: {product.discountPercentage}%</p>
        <p>Rating: {product.rating}</p>
        <p>Stock: {product.stock}</p>
        <p>Brand: {product.brand}</p>
        <p>Category: {product.category}</p>        
        <div className='images' >
          {product.images.map((image, index) => (            
              <img key={index} src={image} alt={`Image ${index + 1}`} />            
          ))}
          </div>
      </div>
    );
  }

export default List