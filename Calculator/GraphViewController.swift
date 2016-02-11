//
//  GraphViewController.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 2/10/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    var scale: CGFloat = 1.0
    
    @IBOutlet weak var graphview: GraphView! {
        didSet {
            graphview.dataSource = self
        }
    }
    var shift: CGPoint = CGPointZero {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        graphview?.setNeedsDisplay()
    }
    
    @IBAction func moveView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended:
            shift = sender.translationInView(graphview)
            sender.setTranslation(CGPointZero, inView: graphview)
        default:
            break
        }
    }
    
    @IBAction func scaleView(sender: UIPinchGestureRecognizer) {
    }
    
    @IBAction func backToOriginal(sender: UITapGestureRecognizer) {
    }
    
    func shiftForGraphView(sender: GraphView) -> CGPoint? {
        return shift
    }
    
}
