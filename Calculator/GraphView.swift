//
//  GraphView.swift
//  Calculator
//
//  Created by Charlie Yuan on 8/8/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var origin: CGPoint! {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    var pointsPerUnit: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Flag to see if we should re-center or not. If the origin ever changes, then do not re-center.
    private var resetOrigin: Bool = true {
        didSet {
            if resetOrigin {
                setNeedsDisplay()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        origin = convertPoint(center, fromView: superview)
    }
    
    override func drawRect(rect: CGRect) {
        if resetOrigin {
            origin = center
        }
        
        let axesDrawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
    }
}