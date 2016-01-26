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
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
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
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if !firstTimeInput {
            enter()
        }
        switch operation {
            
        case "×": performOperation(multiply)
        case "+": performOperation({ (op1: Double, op2: Double) -> Double in return op1+op2})
        case "−": performOperation({(op1,op2) in return op2 - op1})
            //case "−": performOperation({(op1,op2) in op2 - op1})
            //case "−": performOperation({$1 - $1})
            //case "-":performOperation() { $1 - $1 }
        case "÷": performOperation() {$1 / $0}
        case "√": performOperation() {sqrt($0)}
        default: break
            
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    func multiply(op1: Double, op2: Double) -> Double {
        return op1*op2
    }
    // Add private prefix is a fix for overloading error since Swift 1.2
    // Ref: http://stackoverflow.com/questions/29457720/compiler-error-method-with-objective-c-selector-conflicts-with-previous-declara
    private func performOperation(operation: Double -> Double)
    {
        if operandStack.count >= 1
        {
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