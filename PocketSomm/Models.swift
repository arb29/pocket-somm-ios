//
//  Models.swift
//  PocketSomm
//
//  Created by Aaron Baumann on 6/9/25.
//

import Foundation

struct WineEvaluation: Identifiable, Codable {
    let id = UUID()
    let wine: String
    let producer: String
    let vintage: String
    let menuPrice: String
    let retailEstimate: String
    let menuMarkup: String
    let benchmarkMarkup: String
    let finalValueScore: Double
    let priceGrade: String
    let craftGrade: String
    let storyGrade: String
    let vibeGrade: String
    let pairingGrade: String
    let narrativeNote: String
    
    // Grade justifications for interactive display
    let priceJustification: String
    let craftJustification: String
    let storyJustification: String
    let vibeJustification: String
    let pairingJustification: String
    
    init(wine: String = "", producer: String = "", vintage: String = "", menuPrice: String = "", retailEstimate: String = "", menuMarkup: String = "", benchmarkMarkup: String = "", finalValueScore: Double = 0.0, priceGrade: String = "", craftGrade: String = "", storyGrade: String = "", vibeGrade: String = "", pairingGrade: String = "", narrativeNote: String = "", priceJustification: String = "", craftJustification: String = "", storyJustification: String = "", vibeJustification: String = "", pairingJustification: String = "") {
        self.wine = wine
        self.producer = producer
        self.vintage = vintage
        self.menuPrice = menuPrice
        self.retailEstimate = retailEstimate
        self.menuMarkup = menuMarkup
        self.benchmarkMarkup = benchmarkMarkup
        self.finalValueScore = finalValueScore
        self.priceGrade = priceGrade
        self.craftGrade = craftGrade
        self.storyGrade = storyGrade
        self.vibeGrade = vibeGrade
        self.pairingGrade = pairingGrade
        self.narrativeNote = narrativeNote
        self.priceJustification = priceJustification
        self.craftJustification = craftJustification
        self.storyJustification = storyJustification
        self.vibeJustification = vibeJustification
        self.pairingJustification = pairingJustification
    }
}

class WineAnalysisParser {
    static func parseAnalysis(_ text: String) -> [WineEvaluation] {
        let cleanText = text.replacingOccurrences(of: "*", with: "").replacingOccurrences(of: "**", with: "")
        let wineBlocks = cleanText.components(separatedBy: "---").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        return wineBlocks.compactMap { block in
            let lines = block.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
            
            guard !lines.isEmpty else { return nil }
            
            var wine = "", producer = "", vintage = "", menuPrice = "", retailEstimate = "", menuMarkup = "", benchmarkMarkup = "", narrativeNote = ""
            var finalValueScore: Double = 0.0
            var priceGrade = "", craftGrade = "", storyGrade = "", vibeGrade = "", pairingGrade = ""
            var priceJustification = "", craftJustification = "", storyJustification = "", vibeJustification = "", pairingJustification = ""
            
            for line in lines {
                if line.hasPrefix("Wine:") {
                    wine = String(line.dropFirst(5)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Producer:") {
                    producer = String(line.dropFirst(9)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Final Value Score") {
                    if let scoreString = line.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespacesAndNewlines),
                       let score = Double(scoreString) {
                        finalValueScore = score
                    }
                } else if line.hasPrefix("Price Grade:") {
                    priceGrade = String(line.dropFirst(12)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Craft Grade:") {
                    craftGrade = String(line.dropFirst(12)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Story Grade:") {
                    storyGrade = String(line.dropFirst(12)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Vibe Grade:") {
                    vibeGrade = String(line.dropFirst(11)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Pairing Grade:") {
                    pairingGrade = String(line.dropFirst(14)).trimmingCharacters(in: .whitespacesAndNewlines)
                } else if line.hasPrefix("Narrative Note:") {
                    narrativeNote = String(line.dropFirst(15)).trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
            
            return WineEvaluation(
                wine: wine,
                producer: producer,
                vintage: vintage,
                menuPrice: menuPrice,
                retailEstimate: retailEstimate,
                menuMarkup: menuMarkup,
                benchmarkMarkup: benchmarkMarkup,
                finalValueScore: finalValueScore,
                priceGrade: priceGrade,
                craftGrade: craftGrade,
                storyGrade: storyGrade,
                vibeGrade: vibeGrade,
                pairingGrade: pairingGrade,
                narrativeNote: narrativeNote,
                priceJustification: priceJustification,
                craftJustification: craftJustification,
                storyJustification: storyJustification,
                vibeJustification: vibeJustification,
                pairingJustification: pairingJustification
            )
        }
    }
}
