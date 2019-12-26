import Foundation

enum MapErrorKind {
    case missingSpawn(Int)
    case extraSpawn(Int)
    case spawnTooCloseToWall(Int)
    case walkableAtEdge
}

