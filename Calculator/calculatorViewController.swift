//
//  calculatorViewController.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 1/26/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

class calculatorViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var firstTimeInput: Bool = true
    @IBOutlet weak var showHistory: UITextView!
    var brain = CalculatorBrain()
    
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        if digit == "π"
        {
            if(!firstTimeInput)
            {
                enter()
            }
            displayValue = M_PI
            enter()
            return
        }
        if (!firstTimeInput)
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            firstTimeInput = false
        }
    }
    
    @IBAction func appendDot(sender: UIButton) {
        if (!display.text!.containsString("."))
        {
            display.text = display.text! + "."
            firstTimeInput = false
        }
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if !firstTimeInput {
            enter()
        }
        if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = nil
        }
        showHistory.text = showHistory.text! + " " + operation + " = " + display.text! + "\n"
    }
    
    @IBAction func reverseSign(sender: UIButton) {
        if (display.text!.containsString("-"))
        {
            display.text = display.text!.stringByReplacingOccurrencesOfString("-", withString: "")
        }
        else
        {
            display.text = "-" + display.text!
        }
    }
    @IBAction func removeLastDigit(sender: UIButton) {
        if !firstTimeInput
        {
            display.text = String(display.text!.characters.dropLast())
        }
    }

    
    @IBAction func clear() {
        firstTimeInput = true
        display.text = "0"
    }
    
    @IBAction func enter() {
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
        firstTimeInput = true
    }
    
    var displayValue: Double? {
        get {
            if let value = display.text {
                return Double(value)
            } else {
                return 0
            }
        }
        set {
            if let value = newValue {
                display.text = "\(value)"
            } else {
                display.text = String("0")
            }
            firstTimeInput = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}