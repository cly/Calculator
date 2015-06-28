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
        var history = Array<String>()
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
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0"
        history = Array<String>()
        historyDisplay.text = "\(history)"
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            addHistory(operation)
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }

    @IBAction func enter() {
        addOperand()
        addHistory(display.text!)
    }
    
    private func addOperand() {
        userIsInTheMiddleOfTypingANumber = false
        if let validDisplayValue = displayValue {
            if let result = brain.pushOperand(validDisplayValue) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    private func addHistory(item: String) {
        history.insert(item, atIndex: 0)
        historyDisplay.text = "\(history)"
    }
    
    var displayValue: Double? {
        get {
            if let test = NSNumberFormatter().numberFromString(display.text!) {
                return test.doubleValue
            } else {
                return nil
            }
        }
        
        set {
            if let test = newValue {
                display.text = "\(test)"
            } else {
                display.text = "An error has occurred"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}
