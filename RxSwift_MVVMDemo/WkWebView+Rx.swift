//
//  WkWebView+Rx.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/17.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import WebKit

extension Reactive where Base: WKWebView {
    var loading: Binder<String> {
        return Binder(self.base, binding: { (webView, urlStr) in
            webView.load(URLRequest(url: URL(string: urlStr)!))
        })
    }
}

extension Reactive where Base: WKWebView {
    
}
