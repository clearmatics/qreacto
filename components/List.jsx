/**
 * An example of react with fetch
 * @param {Object} product - The product object with the specified structure.
 * @returns {JSX.Element} - The rendered JSX for the product details.
 */
function List({ product }) {
    console.log({product})

    if(!product) return null
    return (
      <div>
        <h2>{product.title}</h2>
        <p>Description: {product.description}</p>
        <p>Price: ${product.price}</p>
        <p>Discount Percentage: {product.discountPercentage}%</p>
        <p>Rating: {product.rating}</p>
        <p>Stock: {product.stock}</p>
        <p>Brand: {product.brand}</p>
        <p>Category: {product.category}</p>
        <img src={product.thumbnail} alt={product.title} />
        <h3>Images:</h3>
        <ul>
          {product.images.map((image, index) => (
            <li key={index}>
              <img src={image} alt={`Image ${index + 1}`} />
            </li>
          ))}
        </ul>
      </div>
    );
  }

export default List