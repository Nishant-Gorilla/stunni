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
import SDWebImage
class CustomImageView: UIImageView {

  let progressIndicatorView = CircularLoaderView(frame: .zero)

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    addSubview(progressIndicatorView)

    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[v]|", options: .init(rawValue: 0),
      metrics: nil, views: ["v": progressIndicatorView]))
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[v]|", options: .init(rawValue: 0),
      metrics: nil, views:  ["v": progressIndicatorView]))
    progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
  }
    
    func loadImage() {
        let jobs = "https://www.whereyougetyourprotein.com/wp-content/uploads/2019/03/in-n-out-vegan-burger-with-fries-and-ketchup-720x405.jpg"
        
        let url = URL(string: jobs)
        
        sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground, progress: { (received, expected, _) in
            self.progressIndicatorView.progress =
                CGFloat(received) / CGFloat(expected)
        }) { (_, _, _, _) in
            self.progressIndicatorView.reveal()
        }
    }
  
}
