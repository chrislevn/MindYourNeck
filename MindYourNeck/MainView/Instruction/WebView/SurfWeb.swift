//
//  SurfWeb.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/15/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit
import WebKit

class SurfWeb: UIViewController, WKUIDelegate  {
    
    var webView: WKWebView!
    var WebTitle = ""
    var link = " "

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = WebTitle
        
        guard let myURL = URL(string: link ) else {return}//change to website later
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
