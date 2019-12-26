import Foundation

enum MapErrorKind {
    case missingSpawn(Int)
    case extraSpawn(Int)
    case spawnTooCloseToWall(Int)
    case walkableAtEdge
}

struct MapError {
    var kind: MapErrorKind
    var position: Position?
}

extension MapError : CustomStringConvertible {
    var description: String {
        func kindDescription() -> String {
            switch kind {
            case .missingSpawn(let spawnNumber):
                return "Missing spawnpoint \(spawnNumber)"
            case .extraSpawn(let spawnNumber):
                return "Extraneous spawnpoint \(spawnNumber)"
            case .spawnTooCloseToWall:
                return "Spawnpoint is too close to a wall"
            case .walkableAtEdge:
                return "A walkable tile is on the edge"
            }
        }
        let positionDescription = position.map { "\($0.description): " } ?? ""
        return positionDescription + kindDescription()
    }
}
