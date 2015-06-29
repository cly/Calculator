//
//  ViewController.swift
//  Calculator
//
//  Created by Charlie Yuan on 6/14/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
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
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        historyDisplay.text = "\(brain.description)"
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
        historyDisplay.text = "\(brain.description)"
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let validDisplayValue = displayValue {
            displayValue = brain.pushOperand(validDisplayValue)
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        
        set {
            if let test = newValue {
                display.text = "\(test)"
            } else {
                clear()
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}
