import Cocoa

class ViewController: NSViewController {

    @IBOutlet var gameBoardView: GameBoardView!
    @IBOutlet var gameBoardTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension ViewController : NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if let map = Map(fromString: gameBoardTextField.stringValue) {
            gameBoardView.board = map
        }
    }
}

