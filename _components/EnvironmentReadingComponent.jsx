import "./style.css";
import * as randomWords from "https://cdn.jsdelivr.net/npm/random-words/+esm";
function EnvironmentReadingComponent() {
  const [text, setText] = React.useState([
    randomWords.generate({ maxLength: 8 }),
  ]);
  return (
    <div
      onClick={() =>
        setText((previous) => [
          ...previous,
          randomWords.generate({ maxLength: 8 }),
        ])
      }
    >
      <div className="styled-component-container">
        {text.map((value) => (
          <span className="wrapper-for-other-component">{value}</span>
        ))}
      </div>
      <div>Environment variables: {process.env.QREACTO_FOO}</div>
      <div>Environment variables: {process.env.QREACTO_TEST}</div>
    </div>
  );
}

export default EnvironmentReadingComponent;
