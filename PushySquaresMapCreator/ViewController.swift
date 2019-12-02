import Cocoa

class ViewController: NSViewController {

    @IBOutlet var gameBoardView: GameBoardView!
    @IBOutlet var gameBoardTextView: NSTextView!
    @IBOutlet var tileSegmentedControl: NSSegmentedControl!
    
    
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
        gameBoardView.board[position] = .empty
    }
    
    func mouseUp(at position: Position) {
        gameBoardView.board[position] = .empty
    }
    
    func boardDidUpdate() {
        gameBoardTextView.string = gameBoardView.board.stringRepresentation
    }
}
