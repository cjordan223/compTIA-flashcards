import SwiftUI

struct FlashcardView: View {
    @State private var isFlipped = false
    @State private var currentIndex: Int // Track the current flashcard index

    var flashcards: [Flashcard]
    var onStatusChange: (Int, Bool) -> Void // Pass index to allow updating

    // Initializer to set the starting index
    init(flashcards: [Flashcard], initialIndex: Int, onStatusChange: @escaping (Int, Bool) -> Void) {
        self.flashcards = flashcards
        self.onStatusChange = onStatusChange
        self._currentIndex = State(initialValue: initialIndex) // Set initial index
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isFlipped ? Color.blue : Color.green)
                    .shadow(radius: 8)

                VStack {
                    Text(isFlipped ? flashcards[currentIndex].answer : flashcards[currentIndex].question)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center) // Ensure text is properly wrapped
                }
                .padding()
            }
            .frame(width: 350, height: 250)
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }

            // Action Buttons
            HStack(spacing: 20) {
                Button(action: { onStatusChange(currentIndex, true) }) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Mark Known")
                    }
                    .frame(maxWidth: .infinity) // Expand buttons to fill space
                }
                .buttonStyle(FlashcardActionButtonStyle(backgroundColor: .green))

                Button(action: { onStatusChange(currentIndex, false) }) {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                        Text("Need Review")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(FlashcardActionButtonStyle(backgroundColor: .red))
            }
            .padding(.horizontal, 16)

            // Pagination Buttons
            HStack {
                Button(action: previousCard) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .disabled(currentIndex == 0) // Disable if at the first card

                Spacer()

                Text("\(currentIndex + 1) of \(flashcards.count)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: nextCard) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                .disabled(currentIndex == flashcards.count - 1) // Disable if at the last card
            }
            .padding(.horizontal, 16)
        }
        .padding() // Add outer padding
    }

    // MARK: - Helper Functions
    private func nextCard() {
        withAnimation {
            currentIndex = min(currentIndex + 1, flashcards.count - 1)
            isFlipped = false // Reset flip state for next card
        }
    }

    private func previousCard() {
        withAnimation {
            currentIndex = max(currentIndex - 1, 0)
            isFlipped = false // Reset flip state for previous card
        }
    }
    
    // Add this at the bottom of FlashcardView.swift
    struct FlashcardActionButtonStyle: ButtonStyle {
        let backgroundColor: Color

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.subheadline)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                        .shadow(radius: configuration.isPressed ? 4 : 8)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }

}
