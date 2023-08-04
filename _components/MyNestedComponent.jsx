import RandomWordsComponent from "./RandomWordsComponent";
import EmojiComponent from "./EmojiComponent";

function MyNestedComponent() {
    return (
      <div>
        <RandomWordsComponent/>
        <EmojiComponent/>
      </div>
    );
  }

export default MyNestedComponent