import MyComponent from "./MyComponent";
function ButtonExample() {
    const handleClick = () => {
      alert('Button clicked!');
    };
  
    return (
      <div>
        <button onClick={handleClick}>Click Me</button>
        <MyComponent />
      </div>
    );
  };

  export default ButtonExample;