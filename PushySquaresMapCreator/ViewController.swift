import Cocoa

class ViewController: NSViewController {

    @IBOutlet var gameBoardView: GameBoardView!
    @IBOutlet var gameBoardTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameBoardView.board = Map(fromString: gameBoardTextField.stringValue)
        gameBoardView.delegate = self
    }


}

extension ViewController : NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if let map = Map(fromString: gameBoardTextField.stringValue) {
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
}
