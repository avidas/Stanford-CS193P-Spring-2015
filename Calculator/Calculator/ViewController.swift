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
    
    var brain = CalculatorBrain()
    
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
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
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
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
            
        }
    }
}

