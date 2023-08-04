import './style.css';
import * as randomWords from 'https://cdn.jsdelivr.net/npm/random-words/+esm';
function RandomWordsComponent() {
    const [text, setText] = React.useState([randomWords.generate({ maxLength: 8 })])
    return (
      <div onClick={() => setText((previous) => [...previous, randomWords.generate({ maxLength: 8 })])}>
        <div className='styled-component-container'>          
          {text.map(value => <span className='wrapper-for-other-component'>{value}</span>)} 
        </div>
      </div>
    );
  }

export default RandomWordsComponent