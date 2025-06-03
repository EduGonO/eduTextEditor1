import { BlockNoteEditor } from "@blocknote/core";
const editor = new BlockNoteEditor({
  element: document.getElementById("root"),
  onChange: () =>
    window.webkit.messageHandlers.editor.postMessage(
      JSON.stringify(editor.document)   // or .topLevelBlocksToMarkdown()
    ),
});