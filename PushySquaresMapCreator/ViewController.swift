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

        board[1, 1] = .spawn1
        board[1, 8] = .spawn2
        board[8, 8] = .spawn3
        board[8, 1] = .spawn4

        board[4, 4] = .wall
        board[4, 5] = .wall
        board[5, 5] = .wall
        board[5, 4] = .wall

        board[1, 2] = .slippery
        board[1, 3] = .grey

        gameBoardView.board = board
        
    }



}

