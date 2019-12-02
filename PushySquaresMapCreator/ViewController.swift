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
        gameBoardView.board[position] = .empty
    }
    
    func boardDidUpdate() {
        gameBoardTextView.string = gameBoardView.board.stringRepresentation
    }
}
