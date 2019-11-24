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

extension NSView {
    var x: CGFloat {
        get { frame.x }
        set { frame.x = newValue }
    }
    
    var y: CGFloat {
        get { frame.y }
        set { frame.y = newValue }
    }
    
    var width: CGFloat {
        get { frame.width }
        set { frame = CGRect(x: x, y: y, width: newValue, height: height) }
    }
    
    var height: CGFloat {
        get { frame.height }
        set { frame = CGRect(x: x, y: y, width: width, height: newValue) }
    }
}

