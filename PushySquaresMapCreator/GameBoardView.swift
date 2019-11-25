import AppKit

class GameBoardView : NSView {
    override var isFlipped: Bool {
        true
    }
    
    var board: Array2D<Tile>! {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    
    let borderSize: CGFloat = 8
    
    
    private func point(for position: Position) -> CGPoint {
        return CGPoint(x: strokeWidth / 2 + position.x.f * squareLength, y: strokeWidth / 2 + position.y.f * squareLength)
    }
    
    private var squareLength: CGFloat {
        return (borderSize * self.width) / (borderSize * max(board.columns.f, board.rows.f) + 1.0)
    }
    
    private var squareViewLength: CGFloat {
        return squareLength - (squareLength / borderSize)
    }
    
    private var strokeWidth: CGFloat {
        return squareLength / borderSize
    }
    
    func squareViewPoint(for position: Position) -> CGPoint {
        let pointForPosition = point(for: position)
        let offset = squareLength / borderSize / 2
        return CGPoint(x: pointForPosition.x + offset, y: pointForPosition.y + offset)
    }
}
