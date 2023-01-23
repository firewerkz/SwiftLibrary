//
//  WebView4.swift
//  Landlord2
//
//  Created by Dick Johnson on 21/07/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//
// From here https://developer.apple.com/forums/thread/126986

import SwiftUI
import WebKit
#if os(macOS)
#else
struct WebView4: UIViewRepresentable {
    @Binding var title: String
    var url: URL
    var loadStatusChanged: ((Bool, Error?) -> Void)?

    func makeCoordinator() -> WebView4.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView4

        init(_ parent: WebView4) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title = webView.title ?? ""
            parent.loadStatusChanged?(false, nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
    }
}

public struct Display: View {
    let site: String
    @State var title: String = ""
    @State var error: Error?

    public init(site: String) {
        self.site = site
    }

    public var body: some View {
        //NavigationView {
        VStack {
            WebView4(title: $title, url: URL(string: site)!)
                .onLoadStatusChanged { loading, error in
                    if loading {
                        print("Loading started")
                        self.title = "Loading…"
                    } else {
                        print("Done loading.")
                        if let error = error {
                            self.error = error
                            if self.title.isEmpty {
                                self.title = "Error"
                            }
                        } else if self.title.isEmpty {
                            self.title = "Some Place"
                        }
                    }
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
        }
    }
}

struct WebView4_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Display(site: "https://www.apple.com/")
        }
    }
}
#endif
