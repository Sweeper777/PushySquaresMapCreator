import AppKit

class TransformsViewController: NSViewController {
    @IBOutlet var regionPopup: NSPopUpButton!
    @IBOutlet var preview: GameBoardView!
    
    var originalMap: Map!
    var transformedMap: Map!
    var transformType: TransformType!
    
    weak var delegate: TransformsViewControllerDelegate?
    
    var selectedRegion: MapRegion {
        MapRegion(rawValue: regionPopup.indexOfSelectedItem)!
    }
    
    @IBAction func ok(_ sender: Any) {
        delegate?.didTransform(transformedMap: transformedMap)
        dismiss(sender)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(sender)
    }
    
}

protocol TransformsViewControllerDelegate : class {
    func didTransform(transformedMap: Map)
}
