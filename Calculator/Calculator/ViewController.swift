//
//  ViewController.swift
//  Calculator
//
//  Created by Das, Ananya on 1/29/15.
//  Copyright (c) 2015 Das, Ananya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    //all properties have to be initialized when class is initialized
    //if it is optional type, the value could be nil
    var userInTheMiddleOfTypingNumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        
        //if nil, it will crash, if a button is not titled and sending 
        //a message, you want program to crash! Crash early
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        
        if userInTheMiddleOfTypingNumber {
            //must unwrap display.text before appending to another string
            //this would crash if display.text is nil
            display.text = display.text! + digit
        } else {
            display.text = digit
            userInTheMiddleOfTypingNumber = true
        }
        
    }
}

