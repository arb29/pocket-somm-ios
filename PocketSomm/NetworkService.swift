//
//  NetworkService.swift
//  PocketSomm
//
//  Created by Aaron Baumann on 6/9/25.
//


import Foundation
import SwiftUI

class NetworkService: ObservableObject {
    @Published var wines: [WineEvaluation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://localhost:3000" // Update with your backend URL
    
    func analyzeWineImage(_ imageData: Data) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let url = URL(string: "\(baseURL)/analyze-wine-image")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"wine_menu.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let responseString = String(data: data, encoding: .utf8) ?? ""
            let parsedWines = WineAnalysisParser.parseAnalysis(responseString)
            
            DispatchQueue.main.async {
                self.wines = parsedWines
                self.isLoading = false
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func reset() {
        wines = []
        errorMessage = nil
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .noData:
            return "No data received"
        }
    }
}