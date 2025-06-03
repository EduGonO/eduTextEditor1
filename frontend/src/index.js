import { BlockNoteEditor } from "@blocknote/core";

console.log("[BlockNote] index.js loaded"); // Log when script is parsed  [oai_citation:4‡medium.com](https://medium.com/%40yeeedward/messaging-between-wkwebview-and-native-application-in-swiftui-e985f0bfacf?utm_source=chatgpt.com)

// Create the editor instance and log its creation
console.log("[BlockNote] Creating editor instance");
const editor = BlockNoteEditor.create();

// Log that we are about to mount the editor
console.log("[BlockNote] Mounting editor to #root");
editor.mount(document.getElementById("root"));

// Once mounted, log the initial document state
console.log("[BlockNote] Initial document state:", JSON.stringify(editor.document));

/**
 * Subscribe to 'change' events. Each time the document changes,
 * send the full document JSON back to Swift and log it locally.
 */
editor.on("change", () => {
  const docJSON = JSON.stringify(editor.document);
  console.log("[BlockNote] Document changed:", docJSON);

  // Post the JSON to Swift via the message handler named "editor"
  window.webkit.messageHandlers.editor.postMessage(docJSON);
  console.log("[BlockNote] Posted document JSON to Swift");
});

// Additionally, listen for focus/blur on the editor for debugging
editor.on("focus", () => {
  console.log("[BlockNote] Editor focused");
});
editor.on("blur", () => {
  console.log("[BlockNote] Editor lost focus");
});