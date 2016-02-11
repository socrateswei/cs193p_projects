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
    func y(x: CGFloat) -> CGFloat?
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
        }
    }
    private func updateScale() {
        if let newScale = dataSource?.scaleForGraphView(self) {
            scale = newScale
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
        // Setting origin and scale
        if (!reset) {
            updateScale()
            updateOrigin()
        } else {
            reset = false
        }

        // Draw axes
        AxesDrawer(contentScaleFactor: contentScaleFactor).drawAxesInRect(rect, origin: newOrigin, pointsPerUnit: scale)

        // Draw data points
        var point = CGPoint()
        let path = UIBezierPath()
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - newOrigin.x) / scale) {
                point.y = newOrigin.y - y * scale
                if (i==0) { path.moveToPoint(point) }
                else { path.addLineToPoint(point) }
            }
        }
        color.set()
        path.lineWidth = lineWidth
        path.stroke()
    }
}