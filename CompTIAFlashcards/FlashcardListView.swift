import SwiftUI

struct FlashcardListView: View {
    @State private var flashcards: [Flashcard] = []
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var progressValue: Double = 0.0  // Keep this as @State

    var filteredFlashcards: [Flashcard] {
        flashcards.filter { flashcard in
            (searchText.isEmpty || flashcard.question.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategory == nil || flashcard.category == selectedCategory)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ProgressView(value: progressValue)
                    .padding()
                    .overlay(
                        Text("\(Int(progressValue * 100))% Known")
                            .foregroundColor(.gray)
                            .font(.caption)
                    )

                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag(String?.none)
                    ForEach(Array(Set(flashcards.map { $0.category })).sorted(), id: \.self) { category in
                        Text(category).tag(String?.some(category))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List(filteredFlashcards) { flashcard in
                    NavigationLink(destination: FlashcardView(flashcard: flashcard, onStatusChange: { isKnown in
                        updateFlashcardStatus(for: flashcard.id, isKnown: isKnown)
                    })) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(flashcard.question)
                                    .font(.headline)
                                Text(flashcard.category)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if flashcard.isKnown {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .swipeActions {
                        Button("Mark Known") {
                            updateFlashcardStatus(for: flashcard.id, isKnown: true)
                        }
                        .tint(.green)

                        Button("Need Review") {
                            updateFlashcardStatus(for: flashcard.id, isKnown: false)
                        }
                        .tint(.orange)
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Flashcards")
                .navigationBarItems(trailing: NavigationLink("Add", destination: AddFlashcardView(flashcards: $flashcards)))
            }
            .onAppear(perform: {
                loadFlashcards()
                updateProgress()
            })
        }
    }

    // MARK: - Actions
    private func updateFlashcardStatus(for id: UUID, isKnown: Bool) {
        if let index = flashcards.firstIndex(where: { $0.id == id }) {
            flashcards[index].isKnown = isKnown
            saveFlashcards()
            updateProgress()
        }
    }

    // MARK: - Progress Calculation
    private func updateProgress() {
        guard !flashcards.isEmpty else {
            progressValue = 0.0
            return
        }
        let knownCards = flashcards.filter { $0.isKnown }
        progressValue = Double(knownCards.count) / Double(flashcards.count)
    }

    // MARK: - Persistence
    private func loadFlashcards() {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("flashcards.json")

        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            flashcards = (try? decoder.decode([Flashcard].self, from: data)) ?? []
        }
        updateProgress()
    }

    private func saveFlashcards() {
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
