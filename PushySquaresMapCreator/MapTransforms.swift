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

// MARK: Slice and Replace
extension Array2D where T == Tile {
    subscript(x1: Int, y1: Int, x2: Int, y2: Int) -> Map {
        get {
            var newMap = Map(columns: x2 - x1 + 1, rows: y2 - y1 + 1, initialValue: .void)
            for x in x1...x2 {
                for y in y1...y2 {
                    newMap[x - x1, y - y1] = self[x, y]
                }
            }
            return newMap
        }
    }
    
    subscript(p1: Position, p2: Position) -> Map {
        get {
            return self[p1.x, p1.y, p2.x, p2.y]
        }
    }
    
    mutating func replace(startingFromX x: Int, y: Int, withMap map: Map) {
        let replacedWidth = Swift.min(map.columns, self.columns - x)
        let replacedHeight = Swift.min(map.rows, self.rows - y)
        for a in 0..<replacedWidth {
            for b in 0..<replacedHeight {
                self[x + a, y + b] = map[a, b]
            }
        }
    }
}

// MARK: Reflect and Rotate Whole Map
extension Array2D where T == Tile {
    func reflectedWholeMapHorizontally() -> Map {
        var newMap = Map(columns: self.columns, rows: self.rows, initialValue: .void)
        self.enumerateTiles(where: {_ in true}) { (x, y, tile) in
            let newX = -x + newMap.columns - 1
            let newY = y
            newMap[newX, newY] = tile
        }
        return newMap
    }
    
}
