//
//  GraphView.swift
//  Calculator
//
//  Created by Tzu-Hao Wei on 2/10/16.
//  Copyright © 2016 Tzu-Hao Wei. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView
{
    @IBInspectable var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    @IBInspectable var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }

    var origin: CGPoint {
        get {
            return convertPoint(center, fromView: superview)
        }
    }

    override func drawRect(rect: CGRect) {
        AxesDrawer().drawAxesInRect(rect, origin: origin, pointsPerUnit: scale)
        color.set()
        let path = UIBezierPath(arcCenter: origin, radius: CGFloat(30.0), startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        path.stroke()
        
    }
}