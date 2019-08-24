//
//  RulesViewController.swift
//  Sansumoku
//
//  Created by Maksim Khrapov on 3/24/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class RulesViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "How to Play"
        
        let url = Bundle.main.url(forResource: "how_to_play", withExtension: "html", subdirectory: "www")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
