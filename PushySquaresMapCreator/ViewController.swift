import Cocoa

class ViewController: NSViewController {

    @IBOutlet var gameBoardView: GameBoardView!
    @IBOutlet var gameBoardTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var board = Array2D<Tile>(columns: 10, rows: 10, initialValue: .void)
        for row in 1..<9 {
            for column in 1..<9 {
                board[row, column] = .empty
            }
        }

    }



}

