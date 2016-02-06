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
    @IBOutlet weak var showHistory: UILabel!

    var firstTimeInput: Bool = true
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        if (!firstTimeInput)
        {
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            firstTimeInput = false
            showHistory.text = brain.description
        }
    }
    
    @IBAction func appendDot(sender: UIButton) {
        if (!display.text!.containsString("."))
        {
            display.text = display.text! + "."
            firstTimeInput = false
        }
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if !firstTimeInput {
            enter()
            print("enter")
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
            print("it's nil")
        }
    }
    
    @IBAction func setVariable(sender: UIButton) {
        if let variable = sender.currentTitle {
            let symbol = variable[variable.endIndex.predecessor()]
            if displayValue != nil {
                brain.variableValues["\(symbol)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            } else {
                displayValue = nil
            }
        }
        firstTimeInput = true
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
            if display.text?.characters.count > 1 {
                display.text = String(display.text!.characters.dropLast())
            } else {
                display.text = "0"
                firstTimeInput = true
            }
        } else {
            if let result = brain.popOperand() {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }

    
    @IBAction func clear() {
        firstTimeInput = true
        brain.clean()
        displayValue = nil
        showHistory.text = ""
    }
    
    @IBAction func enter() {
        firstTimeInput = true
        if displayValue != nil {
            let result = brain.pushOperand(displayValue!)
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if newValue != nil {
                display.text = String(newValue!)
            } else {
                display.text = " "
            }
            firstTimeInput = true
            if brain.description != "" {
                showHistory.text = brain.description + " ="
            } else {
                showHistory.text = brain.description + ""
            }
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