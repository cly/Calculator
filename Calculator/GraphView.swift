//
//  GraphView.swift
//  Calculator
//
//  Created by Charlie Yuan on 8/8/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    var origin: CGPoint! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var pointsPerUnit: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        origin = convertPoint(center, fromView: superview)
    }
    
    override func drawRect(rect: CGRect) {
        let axesDrawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
    }
}