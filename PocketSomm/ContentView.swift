//
//  ContentView.swift
//  PocketSomm
//
//  Created by Aaron Baumann on 6/9/25.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CameraView()
                .tabItem {
                    Image(systemName: "camera")
                    Text("Analyze")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}