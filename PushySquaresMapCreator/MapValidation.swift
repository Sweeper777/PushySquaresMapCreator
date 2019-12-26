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

extension Map {
    
    fileprivate func validateSpawns() -> [MapError] {
        var errors = [MapError]()
        var spawnCounts = [0, 0, 0, 0]
        for (index, spawn) in [Tile.spawn1, .spawn2, .spawn3, .spawn4].enumerated() {
            enumerateTiles(where: { $0 == spawn }) { (x, y, tile) in
                spawnCounts[index] += 1
                if spawnCounts[index] > 1 {
                    errors.append(MapError(kind: .extraSpawn(index + 1), position: Position(x, y)))
                }
            }
        }
        for index in spawnCounts.indices where spawnCounts[index] == 0 {
            errors.append(MapError(kind: .missingSpawn(index + 1), position: nil))
        }
        return errors
    }
    
}
