import Foundation

enum Direction {
    case up, down, left, right

    var opposite: Direction {
        switch self {
        case .up: return .down
        case .down: return .up
        case .left: return .right
        case .right: return .left
        }
    }
}

struct Position: Equatable, Hashable {
    var x: Int
    var y: Int

    func moved(in direction: Direction) -> Position {
        switch direction {
        case .up:
            return Position(x: x, y: y - 1)
        case .down:
            return Position(x: x, y: y + 1)
        case .left:
            return Position(x: x - 1, y: y)
        case .right:
            return Position(x: x + 1, y: y)
        }
    }
}

enum PlayerType {
    case human
    case ai
}

class Player: ObservableObject {
    let type: PlayerType
    @Published var position: Position
    @Published var direction: Direction
    @Published var trail: Set<Position>
    @Published var isAlive: Bool
    let color: String

    init(type: PlayerType, position: Position, direction: Direction, color: String) {
        self.type = type
        self.position = position
        self.direction = direction
        self.trail = [position]
        self.isAlive = true
        self.color = color
    }

    func move() {
        position = position.moved(in: direction)
        trail.insert(position)
    }

    func changeDirection(_ newDirection: Direction) {
        // Prevent 180-degree turns
        if newDirection != direction.opposite {
            direction = newDirection
        }
    }
}

enum GameState {
    case ready
    case playing
    case gameOver
}
