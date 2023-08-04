function MyComponent() {    
    const [text, setText] = React.useState(['Click me'])
    return (
      <div onClick={() => setText((previous) => [previous, ...[' and me']])}>
        <p>{text.map(value => <span>{value}</span>)} </p>
      </div>
    );
  }

export default MyComponent