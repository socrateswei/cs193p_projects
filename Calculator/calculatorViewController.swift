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
    @IBOutlet weak var showHistory: UITextView!

    var firstTimeInput: Bool = true
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        if displayValue == nil {
            displayValue = 0
        }
        if (!firstTimeInput)
        {
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")) { return }
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
    
    @IBAction func getVariable(sender: UIButton) {
        if !firstTimeInput {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func pushVariable(sender: UIButton) {
        if let variable = sender.currentTitle {
            let symbol = variable[variable.endIndex.predecessor()]
            if displayValue != nil {
                brain.variableValues["\(symbol)"] = displayValue
                if let result = brain.evaluate() {
                    displayValue = result
                } else {
                    displayValue = nil
                }
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
        //showHistory.text = showHistory.text! + brain.getHistory()! + "=" + String(displayValue!) + "\n"
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
        if !firstTimeInput && display.text != "0"
        {
            display.text = String(display.text!.characters.dropLast())
        }
    }

    
    @IBAction func clear() {
        firstTimeInput = true
        brain.clean()
        display.text = "0"
    }
    
    @IBAction func enter() {
        if displayValue != nil {
            let _ = brain.pushOperand(displayValue!)
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
                return nil
            }
        }
        set {
            if let value = newValue {
                display.text = "\(value)"
            } else {
                display.text = "error"
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