//
//  GraphViewController.swift
//  Calculator
//
//  Created by Charlie Yuan on 8/8/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit
import Foundation

class GraphViewController: UIViewController {

    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        graphView.origin = CGPoint.zeroPoint
    }
    
}