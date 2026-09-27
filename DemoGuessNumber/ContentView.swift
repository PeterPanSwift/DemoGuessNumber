import SwiftUI

struct ContentView: View {
    @State private var targetNumber = Int.random(in: 1...100)
    @State private var guess = ""
    @State private var message = "輸入一個數字開始挑戰吧！"
    @State private var attemptCount = 0
    @State private var hasWon = false
    @FocusState private var isGuessFieldFocused: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo.opacity(0.9), Color.blue.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                header

                VStack(spacing: 20) {
                    Text(message)
                        .font(.title3.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(hasWon ? .green : .primary)
                        .frame(maxWidth: .infinity, minHeight: 56)

                    TextField("1～100", text: $guess)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($isGuessFieldFocused)
                        .disabled(hasWon)
                        .padding()
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
                        .onSubmit(checkGuess)

                    Button(action: hasWon ? startNewGame : checkGuess) {
                        Label(
                            hasWon ? "再玩一次" : "猜猜看",
                            systemImage: hasWon ? "arrow.clockwise" : "sparkles"
                        )
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(hasWon ? .green : .indigo)
                    .disabled(!hasWon && guess.isEmpty)

                    Label("已猜 \(attemptCount) 次", systemImage: "number.circle")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
                .shadow(color: .black.opacity(0.16), radius: 20, y: 10)
            }
            .padding()
            .frame(maxWidth: 520)
        }
        .onTapGesture {
            isGuessFieldFocused = false
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "questionmark.diamond.fill")
                .font(.system(size: 54))
                .foregroundStyle(.white)

            Text("猜數字")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("我想了一個 1 到 100 的數字")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))
        }
        .accessibilityElement(children: .combine)
    }

    private func checkGuess() {
        isGuessFieldFocused = false

        guard let number = Int(guess), (1...100).contains(number) else {
            message = "請輸入 1 到 100 之間的整數"
            guess = ""
            return
        }

        attemptCount += 1

        if number < targetNumber {
            message = "太小了，再猜大一點！"
        } else if number > targetNumber {
            message = "太大了，再猜小一點！"
        } else {
            message = "答對了！答案就是 \(targetNumber) 🎉"
            hasWon = true
        }

        guess = ""
    }

    private func startNewGame() {
        targetNumber = Int.random(in: 1...100)
        guess = ""
        attemptCount = 0
        hasWon = false
        message = "新的一局，來猜猜看吧！"
        isGuessFieldFocused = true
    }
}

#Preview {
    ContentView()
}
