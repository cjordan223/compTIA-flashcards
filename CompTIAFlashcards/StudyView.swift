import SwiftUI

struct StudyView: View {
    @State private var currentIndex = 0
    @Binding var flashcards: [Flashcard]
    private var totalCards: Int { flashcards.count }
    
    var body: some View {
        VStack {
            if flashcards.isEmpty {
                Text("No flashcards to study!")
            } else {
                VStack {
                    FlashcardView(
                        flashcard: flashcards[currentIndex],
                        onStatusChange: { isKnown in
                            updateFlashcardStatus(isKnown: isKnown)
                        }
                    )
                    .frame(maxHeight: 300)
                    
                    Text(flashcards[currentIndex].isKnown ? "✅ Known" : "❓ Need Review")
                        .font(.headline)
                        .padding()
                    
                    HStack {
                        Button("Mark Known") {
                            updateFlashcardStatus(isKnown: true)
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        
                        Button("Need Review") {
                            updateFlashcardStatus(isKnown: false)
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    }
                    .padding()
                    
                    // Add navigation buttons for previous/next cards
                    HStack {
                        Button(action: previousCard) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .disabled(currentIndex == 0)
                        
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
                        .disabled(currentIndex == totalCards - 1)
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
    
    // MARK: - Helper Functions
    private func updateFlashcardStatus(isKnown: Bool) {
        flashcards[currentIndex].isKnown = isKnown
        
        // Optionally auto-advance to next card after marking
        if currentIndex < totalCards - 1 {
            withAnimation {
                currentIndex += 1
            }
        }
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
