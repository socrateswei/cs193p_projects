//
//  GraphViewController.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 2/10/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    var scale: CGFloat = 1.0 {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var graphview: GraphView! {
        didSet {
            let doubleTapping = UITapGestureRecognizer(target: graphview, action: "resetOriginScale:")
            doubleTapping.numberOfTapsRequired = 2
            doubleTapping.numberOfTouchesRequired = 1
            graphview.addGestureRecognizer(doubleTapping)
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
        if sender.state == .Ended {
            shift = sender.translationInView(graphview)
            sender.setTranslation(CGPointZero, inView: graphview)
        }
    }
    
    @IBAction func scaleView(sender: UIPinchGestureRecognizer) {
        print("pinch gesture")
        if sender.state == .Changed {
            scale *= sender.scale
            sender.scale = 1
        }
    }
    
    func shiftForGraphView(sender: GraphView) -> CGPoint? {
        return shift
    }
    func scaleForGraphView(sender: GraphView) -> CGFloat? {
        return scale
    }
}
