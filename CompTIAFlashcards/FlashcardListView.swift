import SwiftUI

struct FlashcardListView: View {
    @State private var flashcards: [Flashcard] = [] // Ensure this is properly initialized
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var progressValue: Double = 0.0

    var filteredFlashcards: [Flashcard] {
        flashcards.filter { flashcard in
            (searchText.isEmpty || flashcard.question.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategory == nil || flashcard.category == selectedCategory)
        }
    }

    var categories: [String] {
        Array(Set(flashcards.map { $0.category })).sorted()
    }

    var body: some View {
        NavigationView {
            VStack {
                // Reset Button
                Button("Reset All to Unknown") {
                    resetAllFlashcards()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom) // Adds space between reset button and flashcard

                // Progress View
                ProgressView(value: progressValue)
                    .padding()
                    .overlay(
                        Text("\(Int(progressValue * 100))% Known")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )

                // Category Menu
                Menu {
                    Button("All") { selectedCategory = nil }
                    ForEach(categories, id: \.self) { category in
                        Button(category) { selectedCategory = category }
                    }
                } label: {
                    Label(selectedCategory ?? "All Categories", systemImage: "line.horizontal.3.decrease.circle")
                        .padding()
                }

                // Flashcard List
                List(filteredFlashcards) { flashcard in
                    NavigationLink(
                        destination: FlashcardView(
                            flashcards: filteredFlashcards,
                            onStatusChange: { index, isKnown in
                                updateFlashcardStatus(for: filteredFlashcards[index].id, isKnown: isKnown)
                            }
                        )
                    ) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(flashcard.question).font(.headline)
                                Text(flashcard.category).font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            if flashcard.isKnown {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else {
                                Image(systemName: "exclamationmark.circle.fill").foregroundColor(.red)
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Flashcards")
            }
            .onAppear {
                if flashcards.isEmpty { loadFlashcards() }
                updateProgress()
            }
        }
    }

    // MARK: - Helper Functions
    private func updateFlashcardStatus(for id: String, isKnown: Bool) {
        if let index = flashcards.firstIndex(where: { $0.id == id }) {
            flashcards[index].isKnown = isKnown
            saveFlashcards()
            updateProgress()
        }
    }

    private func updateProgress() {
        guard !flashcards.isEmpty else {
            progressValue = 0.0
            return
        }
        let knownCards = flashcards.filter { $0.isKnown }
        progressValue = Double(knownCards.count) / Double(flashcards.count)
    }

    private func loadFlashcards() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("flashcards.json")

        print("JSON file path: \(fileURL)") // Debug log

        if let data = try? Data(contentsOf: fileURL) {
            let decoder = JSONDecoder()
            do {
                let rawData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                print("Total raw entries: \(rawData?.count ?? 0)") // Log total entries in the JSON

                flashcards = try decoder.decode([Flashcard].self, from: data)
                print("Successfully loaded \(flashcards.count) flashcards")
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("JSON file not found or empty")
        }
    }



    private func saveFlashcards() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(flashcards)
            let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("flashcards.json")
            try data.write(to: url)
        } catch {
            print("Error saving flashcards: \(error)")
        }
    }

    private func resetAllFlashcards() {
        for index in flashcards.indices {
            flashcards[index].isKnown = false
        }
        saveFlashcards()
        updateProgress()
    }
}
