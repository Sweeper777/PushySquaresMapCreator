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
