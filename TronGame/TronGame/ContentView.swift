import SwiftUI

struct ContentView: View {
    @State private var showGame = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if showGame {
                GameView(showGame: $showGame)
            } else {
                VStack(spacing: 30) {
                    Text("TRON")
                        .font(.system(size: 60, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan, radius: 10)

                    Text("Light Cycles")
                        .font(.system(size: 24, weight: .light, design: .monospaced))
                        .foregroundColor(.cyan.opacity(0.7))

                    Button(action: {
                        showGame = true
                    }) {
                        Text("START GAME")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.cyan)
                                    .shadow(color: .cyan, radius: 10)
                            )
                    }
                    .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How to Play:")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)

                        Text("• Swipe to change direction")
                        Text("• Avoid walls and trails")
                        Text("• Survive longer than AI")

                    }
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(.cyan.opacity(0.8))
                    .padding(.top, 30)
                }
                .padding()
            }
        }
    }
}
