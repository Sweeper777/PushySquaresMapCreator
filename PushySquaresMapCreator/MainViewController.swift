import Cocoa

class MainViewController: NSViewController {

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
        
        preferredContentSize = CGSize(width: 577, height: 441)
    }


}

extension MainViewController : NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        if let map = Map(fromString: gameBoardTextView.string) {
            gameBoardView.board = map
        }
    }
}

extension MainViewController : GameBoardViewDelegate {
    func mouseMove(to position: Position) {
        if tileSegmentedControl.selectedSegment < 5 {
            gameBoardView.board[position] = segmentedControlTilesOrder[tileSegmentedControl.selectedSegment]
            updateTextView()
        }
    }
    
    func mouseUp(at position: Position) {
        gameBoardView.board[position] = segmentedControlTilesOrder[tileSegmentedControl.selectedSegment]
        updateTextView()
    }
    
    func updateTextView() {
        gameBoardTextView.string = gameBoardView.board.stringRepresentation
    }
}

// MARK: Menu Items

extension MainViewController {
    @objc @IBAction func clearToVoid(_ sender: Any) {
        gameBoardView.board = Map(columns: gameBoardView.board.columns, rows: gameBoardView.board.rows, initialValue: .void)
        updateTextView()
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
        updateTextView()
    }
    
    @objc @IBAction func newBlankMap(_ sender: Any) {
        let a = NSAlert()
        a.messageText = "Please enter the size of the new map:"
        a.addButton(withTitle: "Create")
        a.addButton(withTitle: "Cancel")

        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        inputTextField.placeholderString = "10"
        a.accessoryView = inputTextField
        a.window.initialFirstResponder = inputTextField

        a.beginSheetModal(for: view.window!) { [weak self] modalResponse in
            if modalResponse == .alertFirstButtonReturn {
                let enteredString = inputTextField.stringValue
                guard let size = Int(enteredString) else { return }
                self?.gameBoardView.board = Map(columns: size, rows: size, initialValue: .void)
                self?.updateTextView()
            }
        }
    }
    
    @objc @IBAction func openMap(_ sender: Any) {
        let openFileDialog = NSOpenPanel()
        openFileDialog.allowsMultipleSelection = false
        openFileDialog.canChooseDirectories = false
        openFileDialog.canChooseFiles = true
        openFileDialog.allowedFileTypes = ["map"]
        openFileDialog.allowsOtherFileTypes = false
        
        if openFileDialog.runModal() == .OK {
            guard let url = openFileDialog.url else {
                print("no file selected!")
                return
            }
            do {
                let stringRepresentation = try String(contentsOfFile: url.path)

                guard let map = Map(fromString: stringRepresentation) else {
                    print("invalid map")
                    return
                }
                self.gameBoardView.board = map
                self.updateTextView()
            } catch let error {
                print("error occurred while reading file")
                print(error)
                return
            }
        }
    }
    
    @objc @IBAction func saveAsMap(_ sender: Any) {
        let saveFileDialog = NSSavePanel()
        saveFileDialog.allowedFileTypes = ["map"]
        saveFileDialog.allowsOtherFileTypes = true
        saveFileDialog.canCreateDirectories = true
        saveFileDialog.nameFieldStringValue = "untitled.map"
        
        if saveFileDialog.runModal() == .OK {
            let stringRepresentation = gameBoardView.board.stringRepresentation
            guard let url = saveFileDialog.url else {
                print("no url in NSSavePanel")
                return
            }
            do {
                try stringRepresentation.write(to: url, atomically: false, encoding: .utf8)
            } catch let error {
                print("error occurred while writing file")
                print(error)
            }
        }
    }
    
    @objc @IBAction func enlargeMap(_ sender: Any) {
        gameBoardView.board = gameBoardView.board.enlarged()
        updateTextView()
    }
    
    @objc @IBAction func trimMap(_ sender: Any) {
        gameBoardView.board = gameBoardView.board.trimmed()
        updateTextView()
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(clearToEmpty) {
            guard let map = gameBoardView.board else { return false }
            return map.columns > 2 && map.rows > 2
        }
        
        return super.responds(to: aSelector)
    }
}

// MARK: Shortcut keys for tiles

extension MainViewController {
    @IBAction @objc func didSelectTile(_ sender: NSMenuItem) {
        let index = sender.menu!.items.firstIndex(of: sender)!
        tileSegmentedControl.selectedSegment = index
        sender.menu!.items.forEach { $0.state = .off }
        sender.state = .on
    }
}

