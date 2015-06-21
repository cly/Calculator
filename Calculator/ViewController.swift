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
    var operandStack = Array<Double>()
    var history = Array<String>()
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
        operandStack = Array<Double>()
        display.text = "0"
        history = Array<String>()
        historyDisplay.text = "\(history)"
        println("\(operandStack)")
    }
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            addOperand()
            addHistory(display.text!)
        }
        addHistory(operation)
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation(M_PI)
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            addOperand()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            addOperand()
        }
    }
    
    private func performOperation(constant: Double) {
        displayValue = constant
        addOperand()
    }

    @IBAction func enter() {
        addOperand()
        addHistory(display.text!)
    }
    
    private func addOperand() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("\(operandStack)")
    }
    
    private func addHistory(item: String) {
        history.insert(item, atIndex: 0)
        historyDisplay.text = "\(history)"
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

