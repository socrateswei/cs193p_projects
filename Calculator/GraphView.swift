//
//  GraphView.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 2/10/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func shiftForGraphView(sender: GraphView) -> CGPoint?
    func scaleForGraphView(sender: GraphView) -> CGFloat?
}

@IBDesignable
class GraphView: UIView
{
    @IBInspectable var scale: CGFloat = Constants.DefaultScale { didSet { setNeedsDisplay() } }
    @IBInspectable var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }

    weak var dataSource: GraphViewDataSource?
    
    var origin: CGPoint {
        get {
            return convertPoint(center, fromView: superview)
        }
    }
    private struct Constants {
        static let DefaultScale: CGFloat = 10.0
    }
    
    var newOrigin: CGPoint = CGPointZero
    var reset: Bool = false
    
    private func updateOrigin() {
        if (newOrigin == CGPointZero) {
            newOrigin = origin
        }
        if let shift = dataSource?.shiftForGraphView(self) {
            newOrigin.x = shift.x + newOrigin.x
            newOrigin.y = shift.y + newOrigin.y
        } else {
            newOrigin = origin
            print("Origin = \(origin)")
        }
    }
    private func updateScale() {
        if let newScale = dataSource?.scaleForGraphView(self) {
            scale = newScale
            print("newScale = \(scale)")
        }
    }
    
    func resetOriginScale(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            newOrigin = origin
            scale = Constants.DefaultScale
            reset = true
        }
    }
    
    override func drawRect(rect: CGRect) {
        if (!reset) {
            updateOrigin()
            updateScale()
        } else {
            reset = false
        }
        AxesDrawer().drawAxesInRect(rect, origin: newOrigin, pointsPerUnit: scale)
        color.set()
        let path = UIBezierPath(arcCenter: origin, radius: CGFloat(30.0), startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        path.stroke()
    }
}