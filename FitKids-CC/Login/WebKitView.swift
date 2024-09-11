//
//  WebKitView.swift
//  FitKids-CC
//
//  Created by Zane Sabbagh on 9/5/24.
//

import SwiftUI
import WebKit

struct WebKitView: UIViewRepresentable {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = context.coordinator
        
        if let url = URL(string: "https://fitkids.org/my-account") {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebKitView
        
        init(_ parent: WebKitView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, url.absoluteString.contains("https://fitkids.org/coachs-corner/") {
                parent.isLoggedIn = true
            }
            decisionHandler(.allow)
        }
        
        // Existing method can be removed or kept for additional functionality
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // This method can be removed if not needed for other purposes
        }
    }
}

