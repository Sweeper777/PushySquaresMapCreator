import AppKit

class TransformsViewController: NSViewController {
    @IBOutlet var regionPopup: NSPopUpButton!
    @IBOutlet var preview: GameBoardView!
    
    var originalMap: Map!
    var transformedMap: Map!
    
}

protocol TransformsViewControllerDelegate : class {
    func didTransform(transformedMap: Map)
}
