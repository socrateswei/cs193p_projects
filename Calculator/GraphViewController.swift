//
//  GraphViewController.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 2/10/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource, UIPopoverPresentationControllerDelegate {

    private var newScale: CGFloat = 1.0 {
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
    private var shift: CGPoint = CGPointZero {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        graphview?.setNeedsDisplay()
    }
    
    @IBAction func moveView(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Changed: fallthrough
        case .Ended:
            shift = sender.translationInView(graphview)
            sender.setTranslation(CGPointZero, inView: graphview)
        default:
            break
        }
    }
    
    @IBAction func scaleView(sender: UIPinchGestureRecognizer) {
        if sender.state == .Changed {
            newScale = sender.scale
            shift = CGPointZero
            sender.scale = 1
        }
    }
    
    func shiftForGraphView(sender: GraphView) -> CGPoint? {
        return shift
    }
    func scaleForGraphView(sender: GraphView) -> CGFloat? {
        return newScale
    }
    var brain = CalculatorBrain()
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    func y(x: CGFloat) -> CGFloat? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            statValue["Min"] = min(y,statValue["Min"]!)
            statValue["Max"] = max(y,statValue["Max"]!)
            statValue["Avg"] = statValue["Avg"]! + y
            statValue["Np"] = statValue["Np"]! + 1
            return CGFloat(y)
        } else {
            return nil
        }
    }

    var statValue: [String: Double] = ["Min": Double(Int.max), "Max": Double(Int.min), "Avg": Double(0.0), "Np": Double(0.0)]
    
    private struct Statistic {
        static let SegueIdentifier = "Show Stat"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Statistic.SegueIdentifier:
                if let svc = segue.destinationViewController as? StatisticViewController {
                    if let ppc = svc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    statValue["Avg"] = statValue["Avg"]! / statValue["Np"]!
                    svc.text = statValue.description
                }
            default:
                break
            }
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
