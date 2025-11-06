# Tron Mobile Game

A classic Tron light cycle game built for iOS using Swift and SwiftUI.

## Game Features

- **Classic Tron Gameplay**: Control a light cycle that leaves a trail behind
- **AI Opponent**: Play against an intelligent AI opponent
- **Touch Controls**: Swipe in any direction to control your light cycle
- **Score Tracking**: Track your survival time
- **Smooth Animations**: Fluid game mechanics running at optimal speed
- **Retro Aesthetic**: Cyan and red neon graphics inspired by the original Tron

## How to Play

1. Swipe in any direction (up, down, left, right) to change your light cycle's direction
2. Avoid hitting walls, your own trail, or the AI's trail
3. Try to make the AI crash into a trail before you do
4. Survive as long as possible to increase your score

## Requirements

- Xcode 15.0 or later
- iOS 15.0 or later
- macOS for development

## Installation & Setup

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd ClaudeCodeWeb
   ```

2. Open the Xcode project:
   ```bash
   open TronGame/TronGame.xcodeproj
   ```

3. Select your target device or simulator in Xcode

4. Build and run the project (⌘R)

## Project Structure

```
TronGame/
├── TronGame.xcodeproj/      # Xcode project file
└── TronGame/
    ├── TronGameApp.swift    # Main app entry point
    ├── ContentView.swift    # Main menu view
    ├── GameView.swift       # Game screen and UI
    ├── GameLogic.swift      # Core game mechanics
    ├── Models.swift         # Data models (Player, Direction, Position)
    └── Assets.xcassets/     # App assets and icons
```

## Technical Details

### Architecture

- **SwiftUI**: Modern declarative UI framework
- **Combine**: For reactive game state management
- **Canvas API**: For efficient grid rendering
- **Timer-based Game Loop**: Consistent game updates at 0.15s intervals

### Key Components

- **GameLogic**: Manages game state, player movement, collision detection, and AI
- **Player**: Represents a player (human or AI) with position, direction, and trail
- **GameGridView**: Renders the game grid and player trails using SwiftUI Canvas
- **Touch Controls**: Gesture recognizers for swipe-based directional input

### Game Mechanics

- **Grid-based Movement**: 40x60 cell grid for precise collision detection
- **Trail System**: Each player leaves a permanent trail at visited positions
- **Collision Detection**: Checks for wall hits, trail collisions, and head-on crashes
- **AI Behavior**: Simple pathfinding AI that avoids obstacles and tries to survive

## Future Enhancements

Potential features for future updates:
- Multiple difficulty levels
- Multiplayer support (local and online)
- Power-ups and special abilities
- Different game modes (time trial, survival, etc.)
- Leaderboard and achievements
- Sound effects and background music
- Customizable grid sizes and game speeds

## License

See LICENSE file for details.