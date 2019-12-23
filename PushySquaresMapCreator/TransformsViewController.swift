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
    
    override func viewDidLoad() {
        switch transformType! {
        case .reflect:
            title = "Form Reflectional Symmetry"
        case .rotate:
            title = "Form Rotational Symmetry"
        }
        
        preferredContentSize = CGSize(width: 355, height: 419)
        transformMap()
    }
    
    @IBAction func ok(_ sender: Any) {
        delegate?.didTransform(transformedMap: transformedMap)
        dismiss(sender)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(sender)
    }
    
    @IBAction func popupDidChange(_ sender: Any) {
        transformMap()
    }
    
    func transformMap() {
        transformedMap = originalMap
        switch transformType! {
        case .reflect:
            transformedMap.makeReflectionalSymmetry(withOriginalRegion: selectedRegion)
        case .rotate:
            transformedMap.makeRotationalSymmetry(withOriginalRegion: selectedRegion)
        }
        preview.board = transformedMap
    }
}

protocol TransformsViewControllerDelegate : class {
    func didTransform(transformedMap: Map)
}
