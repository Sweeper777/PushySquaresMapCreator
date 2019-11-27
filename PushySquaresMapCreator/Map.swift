

typealias Map = Array2D<Tile>

extension Array2D where T == Tile {
    init?(fromString string: String) {
        
        let lines = string.split(separator: "\n").filter { $0 != "" }
        guard lines.count > 0 else { return nil }
        let rowCount = lines.count
        let columnCount = lines.map { $0.count }.max()!
        self.init(columns: rowCount, rows: columnCount, initialValue: .void)
        for (x, line) in lines.enumerated() {
            for (y, tileChar) in line.enumerated() {
                guard let tile = Tile(rawValue: tileChar) else { return nil }
                self[x, y] = tile
            }
        }
    }
    
    var stringRepresentation: String {
        var result = ""
        for x in 0..<columns {
            for y in 0..<rows {
                result += "\(self[x, y].rawValue)"
            }
            result += "\n"
        }
        return result
    }
}
