import SwiftUI
struct ContentView: View { var body: some View { TabView { CameraView().tabItem { Image(systemName: "camera"); Text("Analyze") } } } }
