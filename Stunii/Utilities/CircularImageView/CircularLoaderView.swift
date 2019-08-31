/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class CircularLoaderView: UIView {
  let circlePathLayer = CAShapeLayer()
  let circleRadius: CGFloat = 20.0

  var progress: CGFloat {
    get {
      return circlePathLayer.strokeEnd
    }
    set {
      if newValue > 1 {
        circlePathLayer.strokeEnd = 1
      } else if newValue < 0 {
        circlePathLayer.strokeEnd = 0
      } else {
        circlePathLayer.strokeEnd = newValue
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  func configure() {
    circlePathLayer.frame = bounds
    circlePathLayer.lineWidth = 2
    circlePathLayer.fillColor = UIColor.clear.cgColor
    circlePathLayer.strokeColor = UIColor.red.cgColor
    layer.addSublayer(circlePathLayer)
    backgroundColor = .white

    progress = 0
  }

  func circleFrame() -> CGRect {
    var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
    let circlePathBounds = circlePathLayer.bounds
    circleFrame.origin.x = circlePathBounds.midX - circleFrame.midX
    circleFrame.origin.y = circlePathBounds.midY - circleFrame.midY
    return circleFrame
  }

  func circlePath() -> UIBezierPath {
    return UIBezierPath(ovalIn: circleFrame())
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    circlePathLayer.frame = bounds
    circlePathLayer.path = circlePath().cgPath
  }

  func reveal() {
    // 1
    backgroundColor = .clear
    progress = 1
    // 2
    circlePathLayer.removeAnimation(forKey: "strokeEnd")
    // 3
    circlePathLayer.removeFromSuperlayer()
    superview?.layer.mask = circlePathLayer

    // 1
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let finalRadius = sqrt((center.x*center.x) + (center.y*center.y))
    let radiusInset = finalRadius - circleRadius
    let outerRect = circleFrame().insetBy(dx: -radiusInset, dy: -radiusInset)
    let toPath = UIBezierPath(ovalIn: outerRect).cgPath

    // 2
    let fromPath = circlePathLayer.path
    let fromLineWidth = circlePathLayer.lineWidth

    // 3
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    circlePathLayer.lineWidth = 2*finalRadius
    circlePathLayer.path = toPath
    CATransaction.commit()

    // 4
    let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
    lineWidthAnimation.fromValue = fromLineWidth
    lineWidthAnimation.toValue = 2*finalRadius
    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.fromValue = fromPath
    pathAnimation.toValue = toPath

    // 5
    let groupAnimation = CAAnimationGroup()
    groupAnimation.duration = 1
    groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    groupAnimation.animations = [pathAnimation, lineWidthAnimation]

    groupAnimation.delegate = self
    
    circlePathLayer.add(groupAnimation, forKey: "strokeWidth")
  }
}

extension CircularLoaderView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    superview?.layer.mask = nil
  }
}
