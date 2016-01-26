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

            case "×":
                if operandStack.count >= 2
                {
                    displayValue = operandStack.removeLast() * operandStack.removeLast()
                    enter()
                }
            case "+":
                if operandStack.count >= 2
                {
                    displayValue = operandStack.removeLast() + operandStack.removeLast()
                    enter()
            }
            case "−":
                if operandStack.count >= 2
                {
                    displayValue = operandStack.removeLast() - operandStack.removeLast()
                    enter()
            }
            case "÷":
                if operandStack.count >= 2
                {
                    displayValue = operandStack.removeLast() / operandStack.removeLast()
                    enter()
            }
        default: break
            
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