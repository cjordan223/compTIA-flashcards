import SwiftUI

struct AddFlashcardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var flashcards: [Flashcard]

    @State private var question = ""
    @State private var answer = ""
    @State private var category = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Question", text: $question)
                TextField("Answer", text: $answer)
                TextField("Category", text: $category)
            }
            .navigationBarTitle("Add Flashcard", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                let newFlashcard = Flashcard(
                    id: UUID(),
                    question: question,
                    answer: answer,
                    category: category,
                    isKnown: false
                )
                flashcards.append(newFlashcard)
                saveFlashcards()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func saveFlashcards() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(flashcards) {
            let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("flashcards.json")
            try? data.write(to: url)
        }
    }
}
