import * as math from 'https://esm.run/math';

function UseEffect() {
  const [count, setCount] = React.useState(0);

  const a = 5;
  const b = 10;

  // Using the 'add' function from the Math module
  const sum = math.default.add(a, b);
  const handleClick = () => {
    setCount((prevCount) => prevCount + 1);
  };

  return (
    <div>
      <h1>Count: {count}</h1>
      <button onClick={handleClick}>Increment</button>
      <p>Math Sum {sum}</p>
    </div>
  );
}
