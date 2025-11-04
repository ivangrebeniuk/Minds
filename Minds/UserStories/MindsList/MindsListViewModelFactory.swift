//
//  MindsListViewModelFactory.swift
//  Minds
//
//  Created by Иван Гребенюк on 25.09.2025.
//

import Foundation

protocol IMindsListViewModelFactory {
    
    func makeViewModel(_ mind: Mind) -> MindCell.Model
}

final class MindsListViewModelFactory: IMindsListViewModelFactory {
    
    func makeViewModel(_ mind: Mind) -> MindCell.Model {
        let cleanedInput = mind.text.trimmingCharacters(in: .whitespacesAndNewlines)
                
        if let range = cleanedInput.range(of: "\n") {
            let rawTitle = String(cleanedInput[..<range.lowerBound])
            let rawText = String(cleanedInput[range.upperBound...])
            
            let title = rawTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            let text = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            return MindCell.Model(id: mind.id, title: title, text: text.isEmpty ? nil : text)
        } else {
            let title = cleanedInput.trimmingCharacters(in: .whitespacesAndNewlines)
            return MindCell.Model(id: mind.id, title: title, text: nil)
        }
    }
}
