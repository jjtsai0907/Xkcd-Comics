//
//  Webview.swift
//  Xkcd-Comics
//
//  Created by Jia-Jiuan Tsai on 2021-11-24.
//

import Foundation
import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }        
        let request = URLRequest(url: url)
        let wkWebviwe = WKWebView()
        wkWebviwe.load(request)
        return wkWebviwe
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<Webview>) {
        
    }
}
