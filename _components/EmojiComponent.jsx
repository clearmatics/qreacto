import './style.css';
import getRandomEmoji from './emojiservice';
function EmojiComponent() {    
    const [text, setText] = React.useState([getRandomEmoji()])
    return (
      <div onClick={() => setText((previous) => [...previous, getRandomEmoji()])}>
        <div className='styled-component-container'>          
          {text.map(value => <span className='wrapper-for-other-component'>{value}</span>)} 
        </div>
      </div>
    );
  }

export default EmojiComponent