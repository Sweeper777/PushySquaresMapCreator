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
    
}

protocol TransformsViewControllerDelegate : class {
    func didTransform(transformedMap: Map)
}
