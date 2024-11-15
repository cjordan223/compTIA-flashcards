//
//  Flashcard.swift
//  CompTIAFlashcards
//
//  Created by connerjordan on 11/14/24.
//

struct Flashcard: Identifiable, Codable {
    let id: String  // Changed from UUID to String
    var question: String
    var answer: String
    var category: String
    var isKnown: Bool
}


