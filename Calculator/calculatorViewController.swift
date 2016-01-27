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
        switch operation {
        case "×": performOperation() {$0*$1}
        case "−": performOperation() {$1-$0}
        case "÷": performOperation() {$1 / $0}
        case "√": performOperation() {sqrt($0)}
        case "sin": performOperation() {sin($0*M_PI/180)}
        case "cos": performOperation() {cos($0*M_PI/180)}
        default: break
            
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
    
    func performOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2
        {
            showHistory.text = showHistory.text! + String(operandStack[operandStack.count-2]) + " "
            showHistory.text = showHistory.text! + String(operandStack[operandStack.count-1])
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    // Add private prefix is a fix for overloading error since Swift 1.2
    // Ref: http://stackoverflow.com/questions/29457720/compiler-error-method-with-objective-c-selector-conflicts-with-previous-declara
    private func performOperation(operation: Double -> Double)
    {
        if operandStack.count >= 1
        {
            showHistory.text = showHistory.text! + String(operandStack[operandStack.count-1])
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    
    @IBAction func clear() {
        firstTimeInput = true
        operandStack.removeAll()
        display.text = "0"
    }
    
    var operandStack: Array<Double> = []
    
    @IBAction func enter() {
        firstTimeInput = true
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double{
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
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