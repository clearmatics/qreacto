// TypeScript Component
interface GreetingProps {
    name?: string;
  }

  const Greeting: React.FC<GreetingProps> = ({ name }) => {
    const [count, setCount] = React.useState(0);
    const handleClick = () => {
      setCount((prevCount) => prevCount + 1);
    };
    
    return <h1 onClick={handleClick}>Hello, {name ? name : 'stranger'}! {count}</h1>;
  };
