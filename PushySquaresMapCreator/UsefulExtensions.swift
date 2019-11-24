import AppKit

extension CGRect {
    var x: CGFloat {
        get { origin.x }
        set { origin.x = newValue }
    }
    
    var y: CGFloat {
        get { origin.y }
        set { origin.y = newValue }
    }
}

