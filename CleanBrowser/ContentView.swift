//
//  ContentView.swift
//  CleanBrowser
//
//  Created by Natan Facchin on 25/04/2022.
//

import SwiftUI

struct ContentView: View {

@State private var action = WebViewAction.idle
    @State private var state = WebViewState.empty
    @State private var address = "https://duckduckgo.com"
    
    var body: some View {
        VStack {
            navigationToolbar
            errorView
            WebView(action: $action,
                    state: $state,
                    restrictedPages: [])
            Spacer()
        }
    }
    
    private var navigationToolbar: some View {
        HStack(spacing: 10) {
            TextField("Address", text: $address)
            if state.isLoading {
                if #available(iOS 14, macOS 10.15, *) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(x: 0.5, y: 0.5, anchor: .center)
                } else {
                    Text("Loading")
                }
            }
            Spacer()
            Button(action: {
                if let url = URL(string: address) {
                    action = .load(URLRequest(url: url))
                }
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .imageScale(.large)
            }
            Button(action: {
                action = .reload
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .imageScale(.large)
            }
            if state.canGoBack {
                Button(action: {
                    action = .goBack
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                }
            }
            if state.canGoForward {
                Button(action: {
                    action = .goForward
                }) {
                Image(systemName: "chevron.right")
                    .imageScale(.large)
                    
                }
            }
        }.padding()
    }
    
    private var errorView: some View {
        Group {
            if let error = state.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
    }
}
