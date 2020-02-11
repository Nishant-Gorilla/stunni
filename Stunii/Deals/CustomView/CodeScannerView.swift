//
//  CodeScanView.swift
//  Stunii
//
//  Created by inderjeet on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class CodeScannerView: UIView {
    
    @IBInspectable var linesLength: CGFloat = 30
    @IBInspectable var linesWidth: CGFloat = 5
    @IBInspectable var linesColor: UIColor = .red
    
    @IBInspectable var middleLineColor: UIColor = .green
    @IBInspectable var middleLineWidth: CGFloat = 2
    @IBInspectable var middleLineAnimationSpeed: CGFloat = 10
    
    @IBInspectable var paddingInPercentage: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        createView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createView()
    }
    
    private func createView() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        clearsContextBeforeDrawing = true
        self.backgroundColor = .clear
        let topBottomPadding: CGFloat = (frame.height * paddingInPercentage) / 100
        let leftRightPadding: CGFloat = (frame.width * paddingInPercentage) / 100
        
        let leftTopPoint1 = CGPoint(x: frame.minX + leftRightPadding, y: frame.minY + linesLength + topBottomPadding)
        let leftTopPoint2 = CGPoint(x: frame.minX + leftRightPadding, y: frame.minY + topBottomPadding)
        let leftTopPoint3 = CGPoint(x: frame.minX + linesLength + leftRightPadding, y: frame.minY + topBottomPadding)
        
        let rightTopPoint1 = CGPoint(x: frame.maxX - linesLength - leftRightPadding, y: frame.minY + topBottomPadding)
        let rightTopPoint2 = CGPoint(x: frame.maxX - leftRightPadding, y: frame.minY + topBottomPadding)
        let rightTopPoint3 = CGPoint(x: frame.maxX - leftRightPadding, y: frame.minY + linesLength + topBottomPadding)
        
        let rightBottomPoint1 = CGPoint(x: frame.maxX - leftRightPadding , y: frame.height - linesLength - topBottomPadding)
        let rightBottomPoint2 = CGPoint(x: frame.maxX - leftRightPadding, y: frame.height - topBottomPadding)
        let rightBottomPoint3 = CGPoint(x: frame.maxX - linesLength - leftRightPadding, y: frame.height - topBottomPadding)
        
        let leftBottomPoint1 = CGPoint(x: frame.minX + linesLength + leftRightPadding, y: frame.height - topBottomPadding)
        let leftBottomPoint2 = CGPoint(x: frame.minX + leftRightPadding, y: frame.height - topBottomPadding)
        let leftBottomPoint3 = CGPoint(x: frame.minX + leftRightPadding, y: frame.height - linesLength - topBottomPadding)
        
        context.move(to: leftTopPoint1)
        context.addLine(to: leftTopPoint2)
        context.addLine(to: leftTopPoint3)
        
        
        context.move(to: rightTopPoint1)
        context.addLine(to: rightTopPoint2)
        context.addLine(to: rightTopPoint3)
        
        context.move(to: rightBottomPoint1)
        context.addLine(to: rightBottomPoint2)
        context.addLine(to: rightBottomPoint3)
        
        context.move(to: leftBottomPoint1)
        context.addLine(to: leftBottomPoint2)
        context.addLine(to: leftBottomPoint3)
        
        context.setLineWidth(linesWidth)
        context.setStrokeColor(linesColor.cgColor)
        context.strokePath()
    }
    
}
