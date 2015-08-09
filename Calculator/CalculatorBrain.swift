//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Charlie Yuan on 6/20/15.
//  Copyright (c) 2015 Charlie Yuan. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        case Constant(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let key):
                    return key
                case .Constant(let key):
                    return key
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = [String:Double]()
    let constantValues = ["π": M_PI]
    var description: String {
        get {
            var results = [String]()
            var remainingOps = opStack
            
            while true {
                var singleResult = description(remainingOps)
                remainingOps = singleResult.remainingOps
                if let output = singleResult.result {
                    results.insert(output, atIndex: 0)
                    if remainingOps.isEmpty {
                        break
                    }
                } else {
                    break
                }
            }
            
            println(",".join(results))
            return(",".join(results))
        }
    }

    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let symbol, let operation):
                var inner = description(remainingOps)
                if let result = inner.result{
                    return ("\(symbol)(\(result))", inner.remainingOps)
                } else {
                    return ("Error", remainingOps)
                }
            case .BinaryOperation(let symbol, let operation):
                var second = description(remainingOps)
                
                if let secondResult = second.result {
                    var first = description(second.remainingOps)
                    
                    if let firstResult = first.result {
                        return ("(\(firstResult)\(symbol)\(secondResult))", first.remainingOps)
                    } else {
                        return ("(?\(symbol)\(secondResult))", second.remainingOps)
                    }
                } else {
                    return ("Error", remainingOps)
                }
            case .Variable(let key):
                return ("\(key)", remainingOps)
            case .Constant(let key):
                return ("\(key)", remainingOps)
            }
        }
        
        return (nil, ops)
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 }))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", { $1 - $0 }))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("√", sqrt))
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList { // guaranteed to be a PropertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    } else {
                        newOpStack.append(.Variable(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let key):
                return (variableValues[key], remainingOps)
            case .Constant(let key):
                return (constantValues[key], remainingOps)
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        if let key = constantValues[symbol] {
            opStack.append(Op.Constant(symbol))
            return evaluate()
        } else {
            opStack.append(Op.Variable(symbol))
            return evaluate()
        }
    }
    
    func setVariable(symbol: String, value: Double?) -> Double? {
        if let realValue = value {
            variableValues[symbol] = realValue
            return evaluate()
        }
        return nil
    }
    
    func clearAllVariables() {
        variableValues.removeAll()
    }
    
    func clearOpStack() {
        opStack.removeAll()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            return evaluate()
        }
        return nil
    }
}