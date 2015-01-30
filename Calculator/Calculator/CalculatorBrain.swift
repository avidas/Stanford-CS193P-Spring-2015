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
    enum Op {
        case Operand(Double) //Associate type if Op is Operand
        case UnaryOperation(String, (Double) -> Double) //Function is just regular data type
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    //operarand or operator, preferred init syntax over Array<Op>()
    private var opStack = [Op]()
    var knownOps = [String:Op]()
    
    //called when CalculatorBrain instance created
    init() {
        knownOps["x"] = Op.BinaryOperation("x", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    //Tuple makes first appearance
    //Returns result of evaluation and rest of the stack as
    //we need to continue evaluating
    //Implicit let in front of all
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops //copy and its mutable since
            //Immutable value of type only has mutating numbers named
            //Cannot do removeLast since ops is readonly
            //When pass args to functions, unless it is instance of class,
            //arrays and dictionaries are not classes in swift, they are structs (e.g. Double, Int)
            //Classes inheritance, passed by reference as opposed to structs
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
        let (result, _) = evaluate(opStack)
        return result
    }

    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    // Private public in swift
    // If no word, public inside the program
    // Only use public keyword if want public outside the framework
    // Private only private to that object
    // Only non private things should be what we are committed to support
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}