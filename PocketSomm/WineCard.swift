//
//  WineCard.swift
//  PocketSomm
//
//  Created by Aaron Baumann on 6/9/25.
//


import SwiftUI

struct WineCard: View {
    let wine: WineEvaluation
    @State private var selectedGrade: String? = nil
    @State private var showingJustification = false
    @State private var expandedText = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text(wine.wine)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("\(wine.producer) • \(wine.vintage)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Value Score
            HStack {
                Text("Value Score")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(wine.finalValueScore, specifier: "%.1f")")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(valueScoreColor(wine.finalValueScore))
            }
            
            // Pricing Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Menu Price:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(wine.menuPrice)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Retail Est:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(wine.retailEstimate)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Markup:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(wine.menuMarkup)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(markupColor(wine.menuMarkup))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            
            // Interactive Grades Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Tap grades for details")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(0.8)
                
                // Grade Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                    InlineGradeView(title: "Price", grade: wine.priceGrade, isSelected: selectedGrade == "Price") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedGrade = selectedGrade == "Price" ? nil : "Price"
                        }
                    }
                    
                    InlineGradeView(title: "Craft", grade: wine.craftGrade, isSelected: selectedGrade == "Craft") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedGrade = selectedGrade == "Craft" ? nil : "Craft"
                        }
                    }
                    
                    InlineGradeView(title: "Story", grade: wine.storyGrade, isSelected: selectedGrade == "Story") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedGrade = selectedGrade == "Story" ? nil : "Story"
                        }
                    }
                    
                    InlineGradeView(title: "Vibe", grade: wine.vibeGrade, isSelected: selectedGrade == "Vibe") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedGrade = selectedGrade == "Vibe" ? nil : "Vibe"
                        }
                    }
                    
                    InlineGradeView(title: "Pairing", grade: wine.pairingGrade, isSelected: selectedGrade == "Pairing") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedGrade = selectedGrade == "Pairing" ? nil : "Pairing"
                        }
                    }
                }
                
                // Inline Justification Display
                if let selectedGrade = selectedGrade {
                    InlineJustificationView(grade: selectedGrade, justification: justificationText(for: selectedGrade))
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .move(edge: .top)),
                            removal: .opacity.combined(with: .move(edge: .top))
                        ))
                }
            }
            
            // Narrative Note
            VStack(alignment: .leading, spacing: 8) {
                Text("Notes")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(wine.narrativeNote)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(expandedText ? nil : 3)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedText.toggle()
                        }
                    }
            }
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func valueScoreColor(_ score: Double) -> Color {
        switch score {
        case 9.0...10.0: return .green
        case 8.0..<9.0: return .blue
        case 7.0..<8.0: return .orange
        default: return .red
        }
    }
    
    private func markupColor(_ markup: String) -> Color {
        if markup.contains("below") || markup.contains("exceptional") {
            return .green
        } else if markup.contains("above") || markup.contains("high") {
            return .orange
        }
        return .primary
    }
    
    private func justificationText(for grade: String) -> String {
        switch grade {
        case "Price": return wine.priceJustification
        case "Craft": return wine.craftJustification
        case "Story": return wine.storyJustification
        case "Vibe": return wine.vibeJustification
        case "Pairing": return wine.pairingJustification
        default: return ""
        }
    }
}

struct InlineGradeView: View {
    let title: String
    let grade: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isBreathing = false
    
    var body: some View {
        VStack(spacing: 4) {
            Button(action: action) {
                Text(grade)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(gradeColor(grade))
                    .clipShape(Circle())
                    .scaleEffect(isSelected ? 1.1 : (isBreathing ? 1.05 : 1.0))
                    .opacity(isBreathing ? 0.8 : 1.0)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 2)
                            .scaleEffect(isSelected ? 1.2 : 1.0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
    }
    
    private func gradeColor(_ grade: String) -> Color {
        switch grade.prefix(1).uppercased() {
        case "A": return .green
        case "B": return .blue
        case "C": return .orange
        case "D": return .red
        case "F": return .red
        default: return .gray
        }
    }
}

struct InlineJustificationView: View {
    let grade: String
    let justification: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(grade) Grade Justification")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            Text(justification.isEmpty ? "No justification available" : justification)
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
        }
        .padding(.top, 8)
    }
}

#Preview {
    WineCard(wine: WineEvaluation(
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
    ))
    .padding()
}