import { Mic, Square } from "lucide-react";
import { Button } from "../../button";
import "../../../../styles/hidden.css"; // CSSファイルのインポート

export const Microphone = (props: {
  isPlaying: boolean;
  isMicrophoneReady: boolean;
  stopPlaying: () => void;
  startRecognition: () => void;
  stopRecognition: () => void;
}) => {
  const startRecognition = () => {
    props.startRecognition();
  };

  const stopRecognition = () => {
    props.stopRecognition();
  };

  return (
    <>
      {props.isPlaying ? (
        <Button
          size="icon"
          type="button"
          variant={"ghost"}
          onClick={props.stopPlaying}
          className="hidden-icon" // CSSクラスを追加
        >
          <Square size={16} />
        </Button>
      ) : (
        <Button
          type="button"
          size="icon"
          variant={"ghost"}
          onMouseDown={startRecognition}
          onMouseUp={stopRecognition}
          onMouseLeave={stopRecognition}
          className={
            props.isMicrophoneReady ? "bg-red-400 hover:bg-red-400" : "hidden-icon"
          }
          aria-label="Microphone for speech input"
        >
          <Mic size={16} />
        </Button>
      )}
    </>
  );
};
