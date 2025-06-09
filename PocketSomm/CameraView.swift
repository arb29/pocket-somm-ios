//
//  CameraView.swift
//  PocketSomm
//
//  Created by Aaron Baumann on 6/9/25.
//


import SwiftUI
import UIKit

struct CameraView: View {
    @StateObject private var networkService = NetworkService()
    @State private var showingImagePicker = false
    @State private var showingResults = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // App Icon
                Image(systemName: "camera.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.blue)
                
                VStack(spacing: 16) {
                    Text("PocketSomm")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("AI-powered wine menu analysis")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                            Text("Analyze Wine Menu")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(networkService.isLoading)
                    
                    if networkService.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                            
                            Text("Analyzing menu...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    if let errorMessage = networkService.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Analyze")
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingResults) {
                ResultsView(wines: networkService.wines)
            }
            .onChange(of: selectedImage) { image in
                if let image = image,
                   let imageData = image.jpegData(compressionQuality: 0.8) {
                    Task {
                        await networkService.analyzeWineImage(imageData)
                        if !networkService.wines.isEmpty {
                            showingResults = true
                        }
                    }
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraView()
}