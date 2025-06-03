import Foundation   // Needed for Bundle and basic types 
import SwiftUI      // Needed for UIViewRepresentable, @Binding, Context 
import WebKit        // Needed for WKWebView, WKScriptMessageHandler, etc.  [oai_citation:11‡advancedswift.com](https://www.advancedswift.com/get-javascript-errors-from-a-wkwebview-in-swift/?utm_source=chatgpt.com)

public struct BlockNoteView: UIViewRepresentable {
    @Binding public var json: String

    // For debugging: print when the struct is initialized
    public init(json: Binding<String>) {
        self._json = json
        print("[BlockNoteView] init(json:) called")
    }

    // Specify the underlying UIView type
    public typealias UIViewType = WKWebView

    // Create a coordinator that will handle script messages
    public func makeCoordinator() -> Coordinator {
        print("[BlockNoteView] makeCoordinator() called")
        return Coordinator(binding: $json)
    }

    public func makeUIView(context: Context) -> WKWebView {
        // Log entry into makeUIView
        print("[BlockNoteView] makeUIView(context:) called")

        let configuration = WKWebViewConfiguration()

        // Ensure JS is enabled (default is true, but we log it)
        configuration.preferences.javaScriptEnabled = true
        print("[BlockNoteView] JavaScript Enabled: \(configuration.preferences.javaScriptEnabled)")

        // Register the message handler for "editor"
        configuration.userContentController.add(context.coordinator, name: "editor")
        print("[BlockNoteView] Registered script message handler 'editor'")

        let webView = WKWebView(frame: .zero, configuration: configuration)

        // Set a navigation delegate to log page loads and errors
        webView.navigationDelegate = context.coordinator
        print("[BlockNoteView] navigationDelegate set to Coordinator")

        // Load our local index.html from the package bundle
        if let indexURL = Bundle.module.url(
            forResource: "index",
            withExtension: "html",
            subdirectory: "Web"
        ) {
            print("[BlockNoteView] Loading local index.html from \(indexURL.path)")
            webView.loadFileURL(
                indexURL,
                allowingReadAccessTo: indexURL.deletingLastPathComponent()
            )
        } else {
            print("[BlockNoteView] ERROR: index.html not found in Bundle.module/Web")
        }

        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        // Called when SwiftUI wants to update the view
        print("[BlockNoteView] updateUIView(_:context:) called; current json = \(json)")

        // If you need to push Swift’s json back into the editor, you could:
        // let js = "window.editor.replaceDocument(\(json));"
        // webView.evaluateJavaScript(js) { result, error in
        //     print("[BlockNoteView] replaceDocument result:", result ?? "nil", "error:", error?.localizedDescription ?? "none")
        // }
    }

    // MARK: -- Coordinator

    public class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        // Store the binding rather than a full BlockNoteView to allow mutation
        private var binding: Binding<String>

        // Initialize with a Binding so we can set binding.wrappedValue later
        init(binding: Binding<String>) {
            self.binding = binding
            print("[Coordinator] init(binding:) called")
        }

        // This is called whenever JS posts a message to "editor"
        public func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            print("[Coordinator] userContentController(_:didReceive:) called with name: \(message.name)")

            // Confirm message body type
            if let bodyString = message.body as? String {
                print("[Coordinator] Received JS payload: \(bodyString)")

                // Update SwiftUI binding on the main thread
                DispatchQueue.main.async {
                    print("[Coordinator] Updating binding.wrappedValue")
                    self.binding.wrappedValue = bodyString
                }
            } else {
                print("[Coordinator] WARNING: message.body is not a String")
            }
        }

        // MARK: -- WKNavigationDelegate Methods for Logging

        // Called when navigation (page load) starts
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("[Coordinator] WKNavigationDelegate didStartProvisionalNavigation")
        }

        // Called when navigation finishes successfully
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("[Coordinator] WKNavigationDelegate didFinish navigation")
        }

        // Called when navigation fails
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("[Coordinator] WKNavigationDelegate didFail navigation with error: \(error.localizedDescription)")
        }

        // Called if content loading fails
        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("[Coordinator] WKNavigationDelegate didFailProvisionalNavigation with error: \(error.localizedDescription)")
        }
    }
}