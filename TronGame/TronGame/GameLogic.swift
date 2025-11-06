import Foundation
import Combine

class GameLogic: ObservableObject {
    @Published var humanPlayer: Player
    @Published var aiPlayer: Player
    @Published var gameState: GameState = .ready
    @Published var winner: String = ""
    @Published var score: Int = 0

    let gridWidth: Int
    let gridHeight: Int
    private var gameTimer: Timer?
    private let gameSpeed: TimeInterval = 0.15

    init(gridWidth: Int = 40, gridHeight: Int = 60) {
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight

        // Initialize players at opposite corners
        humanPlayer = Player(
            type: .human,
            position: Position(x: gridWidth / 4, y: gridHeight / 2),
            direction: .right,
            color: "cyan"
        )

        aiPlayer = Player(
            type: .ai,
            position: Position(x: 3 * gridWidth / 4, y: gridHeight / 2),
            direction: .left,
            color: "red"
        )
    }

    func startGame() {
        gameState = .playing
        score = 0
        startGameLoop()
    }

    func resetGame() {
        gameTimer?.invalidate()
        gameTimer = nil

        humanPlayer = Player(
            type: .human,
            position: Position(x: gridWidth / 4, y: gridHeight / 2),
            direction: .right,
            color: "cyan"
        )

        aiPlayer = Player(
            type: .ai,
            position: Position(x: 3 * gridWidth / 4, y: gridHeight / 2),
            direction: .left,
            color: "red"
        )

        gameState = .ready
        winner = ""
        score = 0
    }

    private func startGameLoop() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameSpeed, repeats: true) { [weak self] _ in
            self?.updateGame()
        }
    }

    private func updateGame() {
        guard gameState == .playing else { return }

        // AI logic
        updateAI()

        // Move both players
        if humanPlayer.isAlive {
            humanPlayer.move()
            score += 1
        }

        if aiPlayer.isAlive {
            aiPlayer.move()
        }

        // Check collisions
        checkCollisions()

        // Check game over
        if !humanPlayer.isAlive || !aiPlayer.isAlive {
            endGame()
        }
    }

    private func updateAI() {
        guard aiPlayer.isAlive else { return }

        // Simple AI: Try to avoid collisions
        let currentPos = aiPlayer.position
        let currentDir = aiPlayer.direction

        // Check if current direction is safe
        let nextPos = currentPos.moved(in: currentDir)

        if !isSafePosition(nextPos) {
            // Try to find a safe direction
            let directions: [Direction] = [.up, .down, .left, .right]
            let safeDirections = directions.filter { dir in
                dir != currentDir.opposite && isSafePosition(currentPos.moved(in: dir))
            }

            if let safeDir = safeDirections.randomElement() {
                aiPlayer.changeDirection(safeDir)
            }
        }
    }

    private func isSafePosition(_ pos: Position) -> Bool {
        // Check boundaries
        if pos.x < 0 || pos.x >= gridWidth || pos.y < 0 || pos.y >= gridHeight {
            return false
        }

        // Check trails
        if humanPlayer.trail.contains(pos) || aiPlayer.trail.contains(pos) {
            return false
        }

        return true
    }

    private func checkCollisions() {
        // Check human player
        if humanPlayer.isAlive {
            let pos = humanPlayer.position

            // Check boundaries
            if pos.x < 0 || pos.x >= gridWidth || pos.y < 0 || pos.y >= gridHeight {
                humanPlayer.isAlive = false
                return
            }

            // Check collision with trails (excluding current position)
            let otherTrails = humanPlayer.trail.union(aiPlayer.trail)
            if otherTrails.filter({ $0 != pos }).contains(pos) {
                humanPlayer.isAlive = false
                return
            }
        }

        // Check AI player
        if aiPlayer.isAlive {
            let pos = aiPlayer.position

            // Check boundaries
            if pos.x < 0 || pos.x >= gridWidth || pos.y < 0 || pos.y >= gridHeight {
                aiPlayer.isAlive = false
                return
            }

            // Check collision with trails (excluding current position)
            let otherTrails = humanPlayer.trail.union(aiPlayer.trail)
            if otherTrails.filter({ $0 != pos }).contains(pos) {
                aiPlayer.isAlive = false
                return
            }
        }

        // Check head-on collision
        if humanPlayer.position == aiPlayer.position {
            humanPlayer.isAlive = false
            aiPlayer.isAlive = false
        }
    }

    private func endGame() {
        gameTimer?.invalidate()
        gameTimer = nil
        gameState = .gameOver

        if humanPlayer.isAlive && !aiPlayer.isAlive {
            winner = "You Win!"
        } else if !humanPlayer.isAlive && aiPlayer.isAlive {
            winner = "AI Wins!"
        } else {
            winner = "Draw!"
        }
    }

    func changeHumanDirection(_ direction: Direction) {
        guard gameState == .playing else { return }
        humanPlayer.changeDirection(direction)
    }
}
