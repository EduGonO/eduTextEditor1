public struct BlockNoteView: UIViewRepresentable {
    @Binding var json: String
    public func makeCoordinator() -> Coordinator { Coordinator(self) }
    public func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        cfg.userContentController.add(context.coordinator, name: "editor") //  [oai_citation:3‡developer.apple.com](https://developer.apple.com/documentation/webkit/wkscriptmessagehandler?utm_source=chatgpt.com)
        let wv = WKWebView(frame: .zero, configuration: cfg)
        let url = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "Web")!
        wv.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent()) //  [oai_citation:4‡tanaschita.com](https://tanaschita.com/20230911-html-in-swiftui/?utm_source=chatgpt.com)
        return wv
    }
    public func updateUIView(_ wv: WKWebView, context: Context) { }
    public class Coordinator: NSObject, WKScriptMessageHandler {
        let parent: BlockNoteView
        init(_ p: BlockNoteView) { self.parent = p }
        public func userContentController(_ c: WKUserContentController, didReceive m: WKScriptMessage) {
            parent.json = m.body as? String ?? ""
        }
    }
}