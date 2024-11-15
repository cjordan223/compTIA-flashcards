//
//  Flashcard.swift
//  CompTIAFlashcards
//
//  Created by connerjordan on 11/14/24.
//

import Foundation

struct Flashcard: Identifiable, Codable {
    let id: UUID
    var question: String
    var answer: String
    var category: String
    var isKnown: Bool
}

