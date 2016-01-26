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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}