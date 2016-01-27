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
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return "\(symbol)"
                case .BinaryOperation(let symbol, _):
                    return "\(symbol)"
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    
    init() {
        func learnOp (op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1-$0})
        learnOp(Op.BinaryOperation("÷") {$1/$0})
        learnOp(Op.UnaryOperation("√", sqrt))

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
                let operand = operandEvaluate.result
                return (operation(operand!),operandEvaluate.remainOps)
            case .BinaryOperation(_, let operation):
                let operand1Evaluate = evaluate(remainOps)
                if let operand1 = operand1Evaluate.result {
                    let operand2Evaluate = evaluate(operand1Evaluate.remainOps)
                    if let operand2 = operand2Evaluate.result {
                        return (operation(operand1, operand2),operand2Evaluate.remainOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        print("opStack = \(opStack)")
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }

    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}