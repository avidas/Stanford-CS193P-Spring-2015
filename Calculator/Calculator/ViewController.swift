//
//  ViewController.swift
//  Calculator
//
//  Created by Das, Ananya on 1/29/15.
//  Copyright (c) 2015 Das, Ananya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Optional type so by default gets = nil
    @IBOutlet weak var display: UILabel!
    
    //all properties have to be initialized when class is initialized
    //if it is optional type, the value could be nil
    var userInTheMiddleOfTypingNumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        
        //if nil, it will crash, if a button is not titled and sending 
        //a message, you want program to crash! Crash early
        let digit = sender.currentTitle!

        if userInTheMiddleOfTypingNumber {
            //must unwrap display.text before appending to another string
            //this would crash if display.text is nil
            display.text = display.text! + digit
        } else {
            display.text = digit
            userInTheMiddleOfTypingNumber = true
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        if userInTheMiddleOfTypingNumber {
            enter()
        }
        switch operation {
        // closure, no return is needed as swift knows result of expression return something
        // $x are default arguments
        // last argument can get outside parenthesis
        // If only argument get rid of parenthesis
            case "x": performOperation { $0 * $1 }
            case "÷": performOperation { $0 / $1 }
            case "+": performOperation { $0 + $1 }
            case "-": performOperation { $0 - $1 }
            // automatically picks the correct performOperation function with one operand
            case "√": performOperation { sqrt($0) }
            default: break
        }
    }
    
    //performOperation is a function that takes operation as parameter
    //operation is a function that takes two doubles and returns a double
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
        }
    }
    
    //for case square root
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
        }
    }
    
    //Initialize internal stack for numbers using type inference
    var operandStack = Array<Double>()
    
    //Computed properties
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }
    
    //Theres only one enter key and we don't need to talk back to it
    //Buttons can control drag
    @IBAction func enter() {
        userInTheMiddleOfTypingNumber = false
        
        operandStack.append(displayValue)
        //Arrays can be printed as strings this way
        println("operandStack = \(operandStack)")

    }
    
    
}

