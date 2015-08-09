//
//  GraphViewController.swift
//  Calculator
//
//  Created by Charlie Yuan on 8/8/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit
import Foundation

class GraphViewController: UIViewController, GraphViewDataSource {

    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }

    func y(x: CGFloat) -> CGFloat? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            return CGFloat(y)
        }
        return nil
    }
    
    private var brain = CalculatorBrain()
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
}