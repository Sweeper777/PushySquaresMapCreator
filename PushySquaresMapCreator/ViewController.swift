import Cocoa

class ViewController: NSViewController {

    @IBOutlet var gameBoardView: GameBoardView!
    @IBOutlet var gameBoardTextView: NSTextView!
    @IBOutlet var tileSegmentedControl: NSSegmentedControl!
    
    let segmentedControlTilesOrder: [Tile] = [
        .void, .empty, .wall, .grey, .slippery, .spawn1, .spawn2, .spawn3, .spawn4,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameBoardView.board = Map(fromString: gameBoardTextView.string)
        gameBoardView.delegate = self
    }


}

extension ViewController : NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        if let map = Map(fromString: gameBoardTextView.string) {
            gameBoardView.board = map
        }
    }
}

extension ViewController : GameBoardViewDelegate {
    func mouseMove(to position: Position) {
        if tileSegmentedControl.selectedSegment < 5 {
            gameBoardView.board[position] = segmentedControlTilesOrder[tileSegmentedControl.selectedSegment]
        }
    }
    
    func mouseUp(at position: Position) {
        gameBoardView.board[position] = segmentedControlTilesOrder[tileSegmentedControl.selectedSegment]
    }
    
    func boardDidUpdate() {
        gameBoardTextView.string = gameBoardView.board.stringRepresentation
    }
}

// MARK: Menu Items

extension ViewController {
    @objc @IBAction func clearToVoid(_ sender: Any) {
        gameBoardView.board = Map(columns: gameBoardView.board.columns, rows: gameBoardView.board.rows, initialValue: .void)
    }
    
    @objc @IBAction func clearToEmpty(_ sender: Any) {
        var map = gameBoardView.board!
        guard map.columns > 2 && map.rows > 2 else { return }
        for column in 0..<map.columns {
            for row in 0..<map.rows {
                if (1..<(map.columns - 1)).contains(column) && (1..<(map.rows - 1)).contains(row) {
                    map[column, row] = .empty
                } else {
                    map[column, row] = .void
                }
            }
        }
        gameBoardView.board = map
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(clearToEmpty) {
            guard let map = gameBoardView.board else { return false }
            return map.columns > 2 && map.rows > 2
        }
        
        return super.responds(to: aSelector)
    }
}
