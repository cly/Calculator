//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Charlie Yuan on 6/14/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit
import Foundation

class CalculatorViewController: UIViewController {
    
    private var userIsInTheMiddleOfTypingANumber = false
    private var brain = CalculatorBrain()
    @IBOutlet weak var historyDisplay: UILabel!
    @IBOutlet weak var display: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        // If a number or if . is not in value already, then do work.
        if digit.rangeOfString(".") == nil || display.text!.rangeOfString(".") == nil {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func addSymbol(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let symbol = sender.currentTitle {
            displayValue = brain.pushOperand(symbol)
        }
    }
    
    @IBAction func clear() {
        brain.clearAllVariables()
        brain.clearOpStack()
        userIsInTheMiddleOfTypingANumber = false
        displayValue = nil
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let validDisplayValue = displayValue {
            displayValue = brain.pushOperand(validDisplayValue)
        }
    }
    
    @IBAction func setVariable(sender: UIButton) {
        displayValue = brain.setVariable("M", value: displayValue)
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func getVariable(sender: UIButton) {
        enter()
        if let v = brain.pushOperand("M") {
            displayValue = v
        }
    }
    
    private var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set {
            if let test = newValue {
                display.text = "\(test)"
            } else {
                display.text = " "
            }
            historyDisplay.text = "\(brain.description)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        
        // Safely handles segues that are not going to a navigation controller.
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController
        }
        
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "plotGraph":
                    gvc.title = brain.description == "" ? "Graph" : brain.description.componentsSeparatedByString(", ").last
                    gvc.program = brain.program
                default:
                    break
                }
            }
        }
    }
}