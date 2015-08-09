//
//  GraphView.swift
//  Calculator
//
//  Created by Charlie Yuan on 8/8/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}

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
    
    var lineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var dataSource: GraphViewDataSource?
    
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
        
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        var firstValue = true
        var point = CGPoint()
        
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - origin.x) / pointsPerUnit) {
                if !y.isNormal && !y.isZero {
                    continue
                }
                point.y = origin.y - y * pointsPerUnit
                
                if firstValue {
                    path.moveToPoint(point)
                    firstValue = false
                } else {
                    path.addLineToPoint(point)
                }
            }
        }
        path.stroke()
    }
}