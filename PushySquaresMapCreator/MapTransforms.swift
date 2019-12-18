import Foundation

// MARK: Key Positions in Map
extension Array2D where T == Tile {
    var maxX: Int { columns - 1 }
    var maxY: Int { rows - 1 }
    
    var midXLeft: Int { columns / 2 - 1 }
    var midXRight: Int { columns % 2 == 0 ? columns / 2 : columns / 2 + 1 }
    var midYTop: Int { rows / 2 - 1 }
    var midYBottom: Int { rows % 2 == 0 ? rows / 2 : rows / 2 + 1 }
}

// MARK: Enlarge and Trim
extension Array2D where T == Tile {
    func enlarged(by n: Int = 1) -> Map {
        var newMap = Map(columns: self.columns + 2, rows: self.rows + 2, initialValue: .void)
        for x in 1..<(newMap.columns - 1) {
            for y in 1..<(newMap.rows - 1) {
                newMap[x, y] = self[x - 1, y - 1]
            }
        }
        return newMap
    }
    
    func trimmed(by n: Int = 1) -> Map {
        var newMap = Map(columns: self.columns - 2, rows: self.rows - 2, initialValue: .void)
        for x in 0..<newMap.columns {
            for y in 0..<newMap.rows {
                newMap[x, y] = self[x + 1, y + 1]
            }
        }
        return newMap
    }
}
