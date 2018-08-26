//
//  WebViewController.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/17.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setUserInterface() {
        view.addSubview(webView)
        
        
    }
}
