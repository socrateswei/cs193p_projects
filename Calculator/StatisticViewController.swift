//
//  StatisticViewController.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 2/11/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {

    @IBOutlet weak var statisticView: UITextView! {
        didSet {
            statisticView.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            statisticView?.text = text
        }
    }

    override var preferredContentSize: CGSize {
        get {
            if statisticView != nil && presentingViewController != nil {
                return statisticView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
        }
        set { super.preferredContentSize = newValue }
    }
}
