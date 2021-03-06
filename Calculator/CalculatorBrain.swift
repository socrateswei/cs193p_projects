//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 1/27/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import Foundation


class CalculatorBrain {
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double,Double) -> Double)
        case NullaryOperation(String, () -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return "\(symbol)"
                case .BinaryOperation(let symbol, _):
                    return "\(symbol)"
                case .NullaryOperation(let symbol, _):
                    return "\(symbol)"
                case .Variable(let symbol):
                    return "\(symbol)"
                }
            }
        }
        var precedence: Int {
            get {
                switch self {
                case .BinaryOperation(let symbol,_):
                    if symbol == "+" || symbol == "-" {
                        return 1
                    } else { // divide and multiply
                        return 2
                    }
                default:
                    return Int.max
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    enum errorCode
    {
        case DividedByZero
        case SquareOfAnNeg
        case NotEnoughOps
        case VariableNotSet
        case None
        var code: String? {
            get {
                switch self {
                case .DividedByZero:
                    return "Divided by 0"
                case .SquareOfAnNeg:
                    return "SQRT Neg. Number"
                case .NotEnoughOps:
                    return "Not enough Ops"
                case .VariableNotSet:
                    return "M is not set"
                default:
                    return nil
                }
            }
        }
        
        
    }
    private var error = errorCode.None

    var variableValues = [String: Double]()

    init() {
        func learnOp (op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1-$0})
        learnOp(Op.BinaryOperation("÷") {$1/$0})
        learnOp(Op.UnaryOperation("√", sqrt))
//        learnOp(Op.UnaryOperation("sin") {sin($0*M_PI/180)})
//        learnOp(Op.UnaryOperation("cos") {cos($0*M_PI/180)})
//        learnOp(Op.UnaryOperation("tan") {tan($0*M_PI/180)})
        learnOp(Op.UnaryOperation("sin") {sin($0)})
        learnOp(Op.UnaryOperation("cos") {cos($0)})
        learnOp(Op.UnaryOperation("tan") {tan($0)})
        learnOp(Op.NullaryOperation("π", { M_PI }))
        learnOp(Op.NullaryOperation("e", { M_E }))

    }
    
    var description: String {
        get {
            var (result, ops) = ("", opStack)
            while ops.count > 0 {
                var current: String?
                (current, ops, _) = description(ops)
                result = result == "" ? current! : "\(current!), \(result)"
            }
            return result
        }
    }
    private func description (ops: [Op]) -> (result: String?, remainOps: [Op], precedence: Int) {
        if !ops.isEmpty {
            var remainOps = ops
            let op = remainOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (String(format: "%g", operand) , remainOps, op.precedence)
            case .UnaryOperation(let symbol,_):
                let operandEval = description(remainOps)
                if var operand = operandEval.result {
                    if op.precedence > operandEval.precedence {
                        operand = "(\(operand))"
                    }
                    return ("\(symbol) \(operand)", operandEval.remainOps, op.precedence)
                }
            case .BinaryOperation(let symbol,_):
                let operandEval1 = description(remainOps)
                if var operand1 = operandEval1.result {
                    if op.precedence > operandEval1.precedence {
                       operand1 = "(\(operand1))"
                    }
                    let operandEval2 = description(operandEval1.remainOps)
                    if var operand2 = operandEval2.result {
                        if op.precedence > operandEval2.precedence {
                            operand2 = "(\(operand2))"
                        }
                        return ("\(operand2) \(symbol) \(operand1)",operandEval2.remainOps, op.precedence)
                    }
                }
            case .NullaryOperation(let symbol, _):
                return ("\(symbol)",remainOps, op.precedence)
            case .Variable(let symbol):
                return ("\(symbol)",remainOps, op.precedence)
            }
        }
        return ("?", ops, Int.max)
    }

    private func evaluate(ops: [Op]) -> (result: Double?, remainOps: [Op]) {
        if !ops.isEmpty {
            var remainOps = ops
            let op = remainOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluate = evaluate(remainOps)
                if let operand = operandEvaluate.result {
                    return (operation(operand),operandEvaluate.remainOps)
                }
            case .BinaryOperation(_, let operation):
                let operand1Evaluate = evaluate(remainOps)
                if let operand1 = operand1Evaluate.result {
                    let operand2Evaluate = evaluate(operand1Evaluate.remainOps)
                    if let operand2 = operand2Evaluate.result {
                        return (operation(operand1, operand2),operand2Evaluate.remainOps)
                    }
                }
            case .NullaryOperation(_, let operation):
                return (operation(), remainOps)
            case .Variable(let symbol):
                if let _ = variableValues[symbol] {
                    return (variableValues[symbol], remainOps)
                }
                error = .VariableNotSet
                return (nil, remainOps)
            }
            error = .NotEnoughOps
        }
        return (nil, ops)
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
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
    func evaluate() -> Double? {
        //print("opStack = \(opStack)")
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func popOperand() -> Double? {
        if !opStack.isEmpty {
            opStack.removeLast()
        }
        return evaluate()
    }

    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluateAndReportErrors() -> String? {
        error = .None
        let (_,_) = evaluate(opStack)
        return error.code
    }
    
    func clean() {
        opStack.removeAll()
        variableValues.removeAll()
    }
}