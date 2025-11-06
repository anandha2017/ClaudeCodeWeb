import SwiftUI

struct GameView: View {
    @StateObject private var gameLogic = GameLogic()
    @Binding var showGame: Bool
    @State private var dragStart: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Score header
                    HStack {
                        Text("SCORE: \(gameLogic.score)")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)
                            .padding()

                        Spacer()

                        Button(action: {
                            showGame = false
                        }) {
                            Text("EXIT")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.cyan, lineWidth: 2)
                                )
                        }
                        .padding()
                    }

                    // Game grid
                    GameGridView(gameLogic: gameLogic)
                        .gesture(
                            DragGesture(minimumDistance: 20)
                                .onChanged { gesture in
                                    if dragStart == nil {
                                        dragStart = gesture.startLocation
                                    }
                                }
                                .onEnded { gesture in
                                    handleSwipe(start: gesture.startLocation, end: gesture.location)
                                    dragStart = nil
                                }
                        )

                    Spacer()
                }

                // Game Over overlay
                if gameLogic.gameState == .gameOver {
                    VStack(spacing: 30) {
                        Text(gameLogic.winner)
                            .font(.system(size: 48, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)
                            .shadow(color: .cyan, radius: 20)

                        Text("SCORE: \(gameLogic.score)")
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan.opacity(0.8))

                        Button(action: {
                            gameLogic.resetGame()
                            gameLogic.startGame()
                        }) {
                            Text("PLAY AGAIN")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(.black)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.cyan)
                                        .shadow(color: .cyan, radius: 10)
                                )
                        }

                        Button(action: {
                            showGame = false
                        }) {
                            Text("MAIN MENU")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyan)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.cyan, lineWidth: 2)
                                )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black.opacity(0.9))
                            .shadow(radius: 20)
                    )
                }

                // Ready state
                if gameLogic.gameState == .ready {
                    VStack(spacing: 20) {
                        Text("READY")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyan)
                            .shadow(color: .cyan, radius: 10)

                        Text("Swipe to start")
                            .font(.system(size: 18, design: .monospaced))
                            .foregroundColor(.cyan.opacity(0.7))

                        Button(action: {
                            gameLogic.startGame()
                        }) {
                            Text("START")
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
                        .padding(.top, 20)
                    }
                }
            }
        }
    }

    private func handleSwipe(start: CGPoint, end: CGPoint) {
        let deltaX = end.x - start.x
        let deltaY = end.y - start.y

        // Start game on first swipe if in ready state
        if gameLogic.gameState == .ready {
            gameLogic.startGame()
        }

        // Determine direction based on larger delta
        if abs(deltaX) > abs(deltaY) {
            // Horizontal swipe
            if deltaX > 0 {
                gameLogic.changeHumanDirection(.right)
            } else {
                gameLogic.changeHumanDirection(.left)
            }
        } else {
            // Vertical swipe
            if deltaY > 0 {
                gameLogic.changeHumanDirection(.down)
            } else {
                gameLogic.changeHumanDirection(.up)
            }
        }
    }
}

struct GameGridView: View {
    @ObservedObject var gameLogic: GameLogic

    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(
                geometry.size.width / CGFloat(gameLogic.gridWidth),
                geometry.size.height / CGFloat(gameLogic.gridHeight)
            )

            Canvas { context, size in
                // Draw grid lines (subtle)
                context.stroke(
                    Path { path in
                        for i in 0...gameLogic.gridWidth {
                            let x = CGFloat(i) * cellSize
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: CGFloat(gameLogic.gridHeight) * cellSize))
                        }
                        for i in 0...gameLogic.gridHeight {
                            let y = CGFloat(i) * cellSize
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: CGFloat(gameLogic.gridWidth) * cellSize, y: y))
                        }
                    },
                    with: .color(.cyan.opacity(0.1)),
                    lineWidth: 0.5
                )

                // Draw human player trail
                for position in gameLogic.humanPlayer.trail {
                    let rect = CGRect(
                        x: CGFloat(position.x) * cellSize,
                        y: CGFloat(position.y) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(.cyan.opacity(0.8))
                    )
                }

                // Draw human player head
                if gameLogic.humanPlayer.isAlive {
                    let pos = gameLogic.humanPlayer.position
                    let rect = CGRect(
                        x: CGFloat(pos.x) * cellSize,
                        y: CGFloat(pos.y) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(.cyan)
                    )
                }

                // Draw AI player trail
                for position in gameLogic.aiPlayer.trail {
                    let rect = CGRect(
                        x: CGFloat(position.x) * cellSize,
                        y: CGFloat(position.y) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(.red.opacity(0.8))
                    )
                }

                // Draw AI player head
                if gameLogic.aiPlayer.isAlive {
                    let pos = gameLogic.aiPlayer.position
                    let rect = CGRect(
                        x: CGFloat(pos.x) * cellSize,
                        y: CGFloat(pos.y) * cellSize,
                        width: cellSize,
                        height: cellSize
                    )
                    context.fill(
                        Path(roundedRect: rect, cornerRadius: 2),
                        with: .color(.red)
                    )
                }
            }
            .frame(
                width: CGFloat(gameLogic.gridWidth) * cellSize,
                height: CGFloat(gameLogic.gridHeight) * cellSize
            )
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
