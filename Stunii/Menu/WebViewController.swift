//
//  WebViewController.swift
//  Stunii
//
//  Created by inderjeet on 11/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
    var url:URL!
    @IBOutlet  var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WebViewController: WKNavigationDelegate {
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
