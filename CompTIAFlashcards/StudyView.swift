import SwiftUI

struct StudyView: View {
    @State private var currentIndex = 0 // Tracks the current card being shown
    @Binding var flashcards: [Flashcard]
    private var totalCards: Int { flashcards.count }

    var body: some View {
        VStack(spacing: 16) {
            if flashcards.isEmpty {
                Text("No flashcards to study!")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Flashcard View
                VStack(spacing: 16) {
                    FlashcardView(
                        flashcards: flashcards,
                        initialIndex: currentIndex, // Pass the current index as the initialIndex
                        onStatusChange: { index, isKnown in
                            updateFlashcardStatus(for: index, isKnown: isKnown)
                        }
                    )
                    .frame(maxHeight: 300)

                    // Status Indicator
                    Text(flashcards[currentIndex].isKnown ? "✅ Known" : "❓ Need Review")
                        .font(.headline)
                        .padding()

                    // Navigation Buttons
                    HStack {
                        Button(action: previousCard) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .disabled(currentIndex == 0) // Disable if at the first card

                        Spacer()

                        Text("\(currentIndex + 1) of \(totalCards)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Spacer()

                        Button(action: nextCard) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .disabled(currentIndex == totalCards - 1) // Disable if at the last card
                    }
                    .padding()
                }
                .padding()
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Add background color for visibility
        .onAppear {
            // Ensure index is reset if the flashcards array changes
            currentIndex = min(currentIndex, flashcards.count - 1)
        }
    }

    // MARK: - Helper Functions
    private func updateFlashcardStatus(for index: Int, isKnown: Bool) {
        flashcards[index].isKnown = isKnown
    }

    private func nextCard() {
        withAnimation {
            currentIndex = min(currentIndex + 1, totalCards - 1)
        }
    }

    private func previousCard() {
        withAnimation {
            currentIndex = max(currentIndex - 1, 0)
        }
    }
}
