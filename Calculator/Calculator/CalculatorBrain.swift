//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Das, Ananya on 1/30/15.
//  Copyright (c) 2015 Das, Ananya. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    //can have functions and computed properties
    //enum implements Printable protocol
    enum Op: Printable {
        case Operand(Double) //Associate type if Op is Operand
        case UnaryOperation(String, (Double) -> Double) //Function is just regular data type
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    //operarand or operator, preferred init syntax over Array<Op>()
    private var opStack = [Op]()
    var knownOps = [String:Op]()
    
    //called when CalculatorBrain instance created
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("x", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
    }
    
    //Tuple makes first appearance
    //Returns result of evaluation and rest of the stack as is
    //we need to continue evaluating
    //Implicit let in front of all
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops //copy and its mutable
            //Immutable value of type only has mutating numbers named
            //Cannot do removeLast since ops is readonly
            let op = remainingOps.removeLast() //only makes the copy here
            switch op {
            //really is op.Operand
            case .Operand(let operand):
                return (operand, remainingOps)
            //_ is anything
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
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        //could be variable operands, so copying array helps
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
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