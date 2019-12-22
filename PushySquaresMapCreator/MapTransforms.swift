import Foundation

enum TransformType {
    case reflect
    case rotate
}

// MARK: Key Positions in Map
extension Array2D where T == Tile {
    var maxX: Int { columns - 1 }
    var maxY: Int { rows - 1 }
    
    var midXLeft: Int { columns / 2 - 1 }
    var midXRight: Int { columns % 2 == 0 ? columns / 2 : columns / 2 + 1 }
    var midYTop: Int { rows / 2 - 1 }
    var midYBottom: Int { rows % 2 == 0 ? rows / 2 : rows / 2 + 1 }
    
    func topLeft(ofRegion region: MapRegion) -> Position {
        switch region {
        case .topLeftQuarter, .leftHalf, .topHalf: return Position(0, 0)
        case .topRightQuarter, .rightHalf: return Position(midXRight, 0)
        case .bottomLeftQuarter, .bottomHalf: return Position(0, midYBottom)
        case .bottomRightQuarter: return Position(midXRight, midYBottom)
        }
    }
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
    
    mutating func replace(startingFrom position: Position, withMap map: Map) {
        replace(startingFromX: position.x, y: position.y, withMap: map)
    }
}

extension MapRegion {
    func of(_ map: Map) -> Map {
        switch self {
        case .leftHalf: return map[0, 0, map.midXLeft, map.maxY]
        case .rightHalf: return map[map.midXRight, 0, map.maxX, map.maxY]
        case .topHalf: return map[0, 0, map.maxX, map.midYTop]
        case .bottomHalf: return map[0, map.midYBottom, map.maxX, map.maxY]
        case .topLeftQuarter: return map[0, 0, map.midXLeft, map.midYTop]
        case .topRightQuarter: return map[map.midXRight, 0, map.maxX, map.midYTop]
        case .bottomLeftQuarter: return map[0, map.midYBottom, map.midXLeft, map.maxY]
        case .bottomRightQuarter: return map[map.midXRight, map.midYBottom, map.maxX, map.maxY]
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
    
    func reflectedWholeMapVertically() -> Map {
        var newMap = Map(columns: self.columns, rows: self.rows, initialValue: .void)
        self.enumerateTiles(where: {_ in true}) { (x, y, tile) in
            let newX = x
            let newY = -y + newMap.rows - 1
            newMap[newX, newY] = tile
        }
        return newMap
    }
    
    func rotatedWholeMap90DegreesAnticlockwise() -> Map {
        var newMap = Map(columns: self.columns, rows: self.rows, initialValue: .void)
        self.enumerateTiles(where: {_ in true}) { (x, y, tile) in
            let newX = y
            let newY = -x + newMap.rows - 1
            newMap[newX, newY] = tile
        }
        return newMap
    }
    
    func rotatedWholeMap180Degrees() -> Map {
        var newMap = Map(columns: self.columns, rows: self.rows, initialValue: .void)
        self.enumerateTiles(where: {_ in true}) { (x, y, tile) in
            let newX = -y + newMap.columns - 1
            let newY = -x + newMap.rows - 1
            newMap[newX, newY] = tile
        }
        return newMap
    }
}

// MARK: Make Symmetries
extension Array2D where T == Tile {
    mutating func makeReflectionalSymmetry(withOriginalRegion region: MapRegion) {
        let originalRegion = region.of(self)
        let horizontallyReflectedMap = originalRegion.reflectedWholeMapHorizontally()
        let verticallyReflectedMap = originalRegion.reflectedWholeMapVertically()
        let twiceReflectedMap = verticallyReflectedMap.reflectedWholeMapHorizontally()
        switch region {
        case .leftHalf:
            replace(startingFrom: topLeft(ofRegion: .rightHalf), withMap: horizontallyReflectedMap)
        case .rightHalf:
            replace(startingFrom: topLeft(ofRegion: .leftHalf), withMap: horizontallyReflectedMap)
        case .topHalf:
            replace(startingFrom: topLeft(ofRegion: .bottomHalf), withMap: verticallyReflectedMap)
        case .bottomHalf:
            replace(startingFrom: topLeft(ofRegion: .topHalf), withMap: verticallyReflectedMap)
        case .topLeftQuarter:
            replace(startingFrom: topLeft(ofRegion: .topRightQuarter), withMap: horizontallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .bottomLeftQuarter), withMap: verticallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .bottomRightQuarter), withMap: twiceReflectedMap)
        case .topRightQuarter:
            replace(startingFrom: topLeft(ofRegion: .topLeftQuarter), withMap: horizontallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .bottomRightQuarter), withMap: verticallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .bottomLeftQuarter), withMap: twiceReflectedMap)
        case .bottomLeftQuarter:
            replace(startingFrom: topLeft(ofRegion: .bottomRightQuarter), withMap: horizontallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .topLeftQuarter), withMap: verticallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .topRightQuarter), withMap: twiceReflectedMap)
        case .bottomRightQuarter:
            replace(startingFrom: topLeft(ofRegion: .bottomLeftQuarter), withMap: horizontallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .topRightQuarter), withMap: verticallyReflectedMap)
            replace(startingFrom: topLeft(ofRegion: .topLeftQuarter), withMap: twiceReflectedMap)
        }
    }
}
