import SwiftUI
struct CameraView: View { @StateObject private var networkService = NetworkService(); var body: some View { VStack { Text("Camera View"); Button("Analyze Wine Menu") { // Camera implementation }; if networkService.isLoading { ProgressView("Analyzing...") } } } }
