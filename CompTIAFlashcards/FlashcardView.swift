import SwiftUI

struct FlashcardView: View {
    @State private var isFlipped = false
    var flashcard: Flashcard
    var onStatusChange: (Bool) -> Void

    var body: some View {
        VStack {
            ZStack {
                if isFlipped {
                    Text(flashcard.answer)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                } else {
                    Text(flashcard.question)
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .frame(width: 300, height: 200)
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }

            HStack {
                Button("Mark Known") {
                    onStatusChange(true)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Need Review") {
                    onStatusChange(false)
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}
