import AppKit

class ErrorsViewController: NSViewController {
    @IBOutlet var tableView: NSTableView!
    
    var errors: [MapError] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

}


