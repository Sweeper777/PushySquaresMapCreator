import AppKit

class ErrorsViewController: NSViewController {
    @IBOutlet var tableView: NSTableView!
    
    var errors: [MapError] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ErrorsViewController : NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return errors.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "cell"), owner: nil) as? NSTableCellView
        cell?.textField?.stringValue = errors[row].description
        return cell
    }
}


