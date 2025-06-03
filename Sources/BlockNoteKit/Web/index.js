import { BlockNoteEditor } from "@blocknote/core";

function logDebug(message) {
  const dbg = document.getElementById("debug-log");
  const p = document.createElement("p");
  p.textContent = message;
  dbg.appendChild(p);
}

logDebug("[A] index.js loaded");

logDebug("[B] Creating BlockNoteEditor instance");
const editor = BlockNoteEditor.create();

logDebug("[C] Mounting editor to #root");
editor.mount(document.getElementById("root"));

logDebug("[D] Mounted. Initial document: " + JSON.stringify(editor.document));

editor.on("change", () => {
  const docJSON = JSON.stringify(editor.document);
  logDebug("[E] Document changed: " + docJSON);

  window.webkit.messageHandlers.editor.postMessage(docJSON);
  logDebug("[F] Posted document JSON to Swift");
});

editor.on("focus", () => {
  logDebug("[G] Editor focused");
});
editor.on("blur", () => {
  logDebug("[H] Editor blurred");
});