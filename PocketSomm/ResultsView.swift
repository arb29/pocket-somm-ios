//
//  ResultsView.swift
//  PocketSomm
//
//  Created by Aaron Baumann on 6/9/25.
//


import SwiftUI

struct ResultsView: View {
    let wines: [WineEvaluation]
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Header Statistics
                    if !wines.isEmpty {
                        VStack(spacing: 16) {
                            Text("Wine Analysis Complete")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            HStack(spacing: 20) {
                                StatCard(title: "Wines", value: "\(wines.count)")
                                StatCard(title: "Avg Score", value: String(format: "%.1f", averageScore))
                                StatCard(title: "Best Value", value: topWine?.wine.prefix(15).appending("...") ?? "N/A")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    // Wine Cards
                    ForEach(wines.sorted { $0.finalValueScore > $1.finalValueScore }) { wine in
                        WineCard(wine: wine)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        showingShareSheet = true
                    }
                    .disabled(wines.isEmpty)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(wines: wines)
            }
        }
    }
    
    private var averageScore: Double {
        guard !wines.isEmpty else { return 0.0 }
        return wines.map { $0.finalValueScore }.reduce(0, +) / Double(wines.count)
    }
    
    private var topWine: WineEvaluation? {
        wines.max { $0.finalValueScore < $1.finalValueScore }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

struct ShareSheet: View {
    let wines: [WineEvaluation]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Share Analysis")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Generated \(wines.count) wine analysis\(wines.count > 1 ? "es" : "")")
                    .foregroundColor(.secondary)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(wines) { wine in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(wine.wine)
                                    .fontWeight(.medium)
                                Text("Score: \(wine.finalValueScore, specifier: "%.1f")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Share")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        // Implement share functionality
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ResultsView(wines: [
        WineEvaluation(
            wine: "689 Cellars Ramsay Pinot Noir 2022",
            producer: "689 Cellars",
            vintage: "2022",
            menuPrice: "$50",
            retailEstimate: "$20",
            menuMarkup: "2.5x",
            benchmarkMarkup: "2.4x (California average)",
            finalValueScore: 8.5,
            priceGrade: "B+",
            craftGrade: "B",
            storyGrade: "B-",
            vibeGrade: "A",
            pairingGrade: "A",
            narrativeNote: "The 689 Cellars Ramsay Pinot Noir 2022 is a crowd-pleaser, blending smooth tannins with rich berry notes.",
            priceJustification: "Slightly above benchmark markup.",
            craftJustification: "Solid production with reliable quality.",
            storyJustification: "Well-known but lacks unique narrative.",
            vibeJustification: "Perfect fit for a relaxed, casual dining atmosphere.",
            pairingJustification: "Versatile with various dishes, especially poultry and light meats."
        )
    ])
}