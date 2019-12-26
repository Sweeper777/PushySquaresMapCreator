import AppKit

class GameBoardView : NSView {
    
    weak var delegate: GameBoardViewDelegate?
    
    override var isFlipped: Bool {
        true
    }
    
    var board: Array2D<Tile>! {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    
    var showVerticalRule: Bool = false {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    
    var showHorizontalRule: Bool = false {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    
    let borderSize: CGFloat = 8
    
    // MARK: Drawing methods
    
    fileprivate func drawVoids() {
        board.enumerateTiles(where: { $0 == .void}) { x, y, _ in
            let path = NSBezierPath(rect: CGRect(origin: point(for: Position(x, y)), size: CGSize(width: squareLength, height: squareLength)))
            NSColor.textColor.setStroke()
            path.lineWidth = 0.5
            path.stroke()
        }
    }
    
    fileprivate func drawNonVoidOutlines() {
        board.enumerateTiles(where: { $0 != .void}) { x, y, _ in
            let path = NSBezierPath(rect: CGRect(origin: point(for: Position(x, y)), size: CGSize(width: squareLength, height: squareLength)))
            NSColor.black.setStroke()
            NSColor(red: 1, green: 0.953125, blue: 0.828125, alpha: 1).setFill()
            path.lineWidth = strokeWidth
            path.fill()
            path.stroke()
        }
    }
    
    fileprivate func drawSpawns() {
        board.enumerateTiles(where: [Tile.spawn1, .spawn2, .spawn3, .spawn4].contains) { x, y, tile in
            if tile == .spawn1 {
                NSColor.red.setStroke()
            } else if tile == .spawn2 {
                NSColor.blue.setStroke()
            } else if tile == .spawn3 {
                NSColor.green.setStroke()
            } else if tile == .spawn4 {
                NSColor.yellow.setStroke()
            }
            let path = NSBezierPath(rect: CGRect(origin: point(for: Position(x, y)), size: CGSize(width: squareLength, height: squareLength)))
            path.lineWidth = strokeWidth
            path.stroke()
        }
    }
    
    fileprivate func drawSpecialSquares() {
        board.enumerateTiles(where: { _ in true }) { x, y, tile in
            if tile == .wall {
                drawInnerSquare(at: Position(x, y), color: .white)
            } else if tile == .grey {
                drawInnerSquare(at: Position(x, y), color: .gray)
            } else if tile == .slippery {
                NSImage(named: "wet")?.draw(in: CGRect(
                    origin: point(for: Position(x, y)),
                    size: CGSize(width: squareLength, height: squareLength)))
            }
        }
    }
    
    fileprivate func drawVerticalRule() {
        let rulePath = NSBezierPath()
        let x = (point(for: Position(board.columns - 1, 0)).x +
                    squareLength -
                    point(for: Position(0, 0)).x) / 2
        let startY = point(for: Position(0, 0)).y
        let endY = point(for: Position(0, board.rows)).y
        rulePath.move(to: CGPoint(x: x, y: startY))
        rulePath.line(to: CGPoint(x: x, y: endY))
        rulePath.lineWidth = strokeWidth * 2
        NSColor.secondaryLabelColor.setStroke()
        rulePath.stroke()
    }
    
    fileprivate func drawHorizontalRule() {
        let rulePath = NSBezierPath()
        let y = (point(for: Position(0, board.rows - 1)).y +
                    squareLength -
                    point(for: Position(0, 0)).y) / 2
        let startX = point(for: Position(0, 0)).x
        let endX = point(for: Position(board.columns, 0)).x
        rulePath.move(to: CGPoint(x: startX, y: y))
        rulePath.line(to: CGPoint(x: endX, y: y))
        rulePath.lineWidth = strokeWidth * 2
        NSColor.secondaryLabelColor.setStroke()
        rulePath.stroke()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard board != nil else { return }
        
        drawVoids()
        drawNonVoidOutlines()
        drawSpawns()
        drawSpecialSquares()
        
        if showVerticalRule {
            drawVerticalRule()
        }
        if showHorizontalRule {
            drawHorizontalRule()
        }
    }
    
    // MARK: Drawing helpers
    
    func drawInnerSquare(at position: Position, color: NSColor) {
        let fillPathRect = CGRect(origin: innerSquarePoint(for: position), size: CGSize(width: innerSquareLength, height: innerSquareLength))
        let fillPath = NSBezierPath(rect: fillPathRect)
        color.setFill()
        fillPath.fill()
        let shadowPath = NSBezierPath()
        let strokeWidth = innerSquareLength / 8
        shadowPath.move(to: CGPoint(
            x: fillPathRect.x + innerSquareLength - strokeWidth / 2,
            y: fillPathRect.y))
        shadowPath.line(to: CGPoint(
            x: fillPathRect.x + innerSquareLength - strokeWidth / 2,
            y: fillPathRect.y + innerSquareLength - strokeWidth / 2))
        shadowPath.line(to: CGPoint(x: fillPathRect.x, y: fillPathRect.y + innerSquareLength - strokeWidth / 2))
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
    
    private var innerSquareLength: CGFloat {
        return squareLength - (squareLength / borderSize)
    }
    
    private var strokeWidth: CGFloat {
        return squareLength / borderSize
    }
    
    func innerSquarePoint(for position: Position) -> CGPoint {
        let pointForPosition = point(for: position)
        let offset = squareLength / borderSize / 2
        return CGPoint(x: pointForPosition.x + offset, y: pointForPosition.y + offset)
    }
}

// MARK: Mouse events handling

extension GameBoardView {
    override func mouseUp(with event: NSEvent) {
        let locationInSelf = convertWindowCoordinateToViewCoordinate(event.locationInWindow)
        guard bounds.contains(locationInSelf) else { return }
        delegate?.mouseUp(at: convertMouseCoordinateToPosition(locationInSelf))
    }
    
    override func mouseDragged(with event: NSEvent) {
        let locationInSelf = convertWindowCoordinateToViewCoordinate(event.locationInWindow)
        guard bounds.contains(locationInSelf) else { return }
        delegate?.mouseMove(to: convertMouseCoordinateToPosition(locationInSelf))
    }
    
    override func mouseDown(with event: NSEvent) {
        let locationInSelf = convertWindowCoordinateToViewCoordinate(event.locationInWindow)
        guard bounds.contains(locationInSelf) else { return }
        delegate?.mouseMove(to: convertMouseCoordinateToPosition(locationInSelf))
    }
    
    func convertWindowCoordinateToViewCoordinate(_ windowCoordinate: CGPoint) -> CGPoint {
        return convert(windowCoordinate, from: self.window?.contentView)
    }
    
    func convertMouseCoordinateToPosition(_ mouseCoordinate: CGPoint) -> Position {
        return Position(
            Int((mouseCoordinate.x - strokeWidth) / squareLength),
            Int((mouseCoordinate.y - strokeWidth) / squareLength)
        )
    }
}
