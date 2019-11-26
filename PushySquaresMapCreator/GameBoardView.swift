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
    
    override func draw(_ dirtyRect: NSRect) {
        guard board != nil else { return }
        for x in 0..<board.columns {
            for y in 0..<board.rows {
                if board[x, y] != .void {
                    let path = NSBezierPath(rect: CGRect(origin: point(for: Position(x, y)), size: CGSize(width: squareLength, height: squareLength)))
                    NSColor.black.setStroke()
                    NSColor(red: 1, green: 0.953125, blue: 0.828125, alpha: 1).setFill()
                    path.lineWidth = strokeWidth
                    path.fill()
                    path.stroke()
                }
            }
        }
        
        for x in 0..<board.columns {
            for y in 0..<board.rows {
                if [Tile.spawn1, .spawn2, .spawn3, .spawn4].contains(board[x, y]) {
                    if board[x, y] == .spawn1 {
                        NSColor.red.setStroke()
                    } else if board[x, y] == .spawn2 {
                        NSColor.blue.setStroke()
                    } else if board[x, y] == .spawn3 {
                        NSColor.green.setStroke()
                    } else if board[x, y] == .spawn4 {
                        NSColor.yellow.setStroke()
                    }
                    let path = NSBezierPath(rect: CGRect(origin: point(for: Position(x, y)), size: CGSize(width: squareLength, height: squareLength)))
                    path.lineWidth = strokeWidth
                    path.stroke()
                }
            }
        }
        
        for x in 0..<board.columns {
            for y in 0..<board.rows {
                if board[x, y] == .wall {
                    addSquareView(at: Position(x, y), color: .white)
                } else if board[x, y] == .grey {
                    addSquareView(at: Position(x, y), color: .gray)
                } else if board[x, y] == .slippery {
                    NSImage(named: "wet")?.draw(in: CGRect(
                        origin: point(for: Position(x, y)),
                        size: CGSize(width: squareLength, height: squareLength)))
                }
            }
        }
    }
    
    func addSquareView(at position: Position, color: NSColor) {
        let fillPathRect = CGRect(origin: squareViewPoint(for: position), size: CGSize(width: squareViewLength, height: squareViewLength))
        let fillPath = NSBezierPath(rect: fillPathRect)
        color.setFill()
        fillPath.fill()
        let shadowPath = NSBezierPath()
        let strokeWidth = squareViewLength / 8
        shadowPath.move(to: CGPoint(
            x: fillPathRect.x + squareViewLength - strokeWidth / 2,
            y: fillPathRect.y))
        shadowPath.line(to: CGPoint(
            x: fillPathRect.x + squareViewLength - strokeWidth / 2,
            y: fillPathRect.y + squareViewLength - strokeWidth / 2))
        shadowPath.line(to: CGPoint(x: fillPathRect.x, y: fillPathRect.y + squareViewLength - strokeWidth / 2))
        color.shadow(withLevel: 0.3)!.setStroke()
        shadowPath.lineWidth = strokeWidth
        shadowPath.stroke()
    }
    
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
