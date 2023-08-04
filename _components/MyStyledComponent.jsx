import './style.css';
function MyStyledComponent() {    
    const [text, setText] = React.useState([])
    return (
      <div onClick={() => setText((previous) => [...previous, ' and this one'])}>
        <div className='styled-component-container'>
          <span className='wrapper-for-other-component'>Click this one</span> 
          {text.map(value => <span className='wrapper-for-other-component'>{value}</span>)} 
        </div>
      </div>
    );
  }

export default MyStyledComponent