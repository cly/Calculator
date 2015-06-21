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

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    var userIsInTheMiddleOfTypingAFloat = false
    var operandStack = Array<Double>()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendDot() {
        if !userIsInTheMiddleOfTypingAFloat {
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + "."
            } else {
                display.text = "0."
                userIsInTheMiddleOfTypingANumber = true
            }
            userIsInTheMiddleOfTypingAFloat = true
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        userIsInTheMiddleOfTypingAFloat = false
        operandStack = Array<Double>()
        display.text = "0"
        println("\(operandStack)")
    }
    
    @IBAction func appendPi() {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
        
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userIsInTheMiddleOfTypingAFloat = false
        operandStack.append(displayValue)
        println("\(operandStack)")
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

