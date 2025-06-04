// No import statements

function logDebug(msg) {
  const dbg = document.getElementById("debug-log");
  if (dbg) {
    const p = document.createElement("p");
    p.textContent = msg;
    dbg.appendChild(p);
  }
}

logDebug("[index.js] loaded (no import)");

if (typeof BlockNoteEditor === "undefined") {
  logDebug("[ERROR] BlockNoteEditor is undefined");
} else {
  logDebug("[index.js] BlockNoteEditor exists as global");

  try {
    const root = document.getElementById("root");
    if (!root) throw new Error("No #root div found");

    const editor = BlockNoteEditor.create();
    editor.mount(root);

    editor.on("change", () => {
      const docJSON = JSON.stringify(editor.document);
      logDebug("[index.js] Document changed: " + docJSON);
      if (window.webkit?.messageHandlers?.editor) {
        window.webkit.messageHandlers.editor.postMessage(docJSON);
      }
    });

    logDebug("[index.js] Editor mounted and change handler attached");
  } catch (err) {
    logDebug("[index.js ERROR] " + err.message);
  }
}