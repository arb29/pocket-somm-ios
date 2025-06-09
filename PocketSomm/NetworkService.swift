import Foundation
class NetworkService: ObservableObject { @Published var wines: [WineEvaluation] = []; @Published var isLoading = false; func analyzeWineImage(_ imageData: Data) async { DispatchQueue.main.async { self.isLoading = true }; // Network call implementation; DispatchQueue.main.async { self.isLoading = false } } }
