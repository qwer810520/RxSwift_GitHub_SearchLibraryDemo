//
//  ViewModel.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/14.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import RxSwift

class ViewModel {
    
    //****輸入部分****
    //查詢行為
    fileprivate let searchAction: Observable<String>
    
    //****輸出部分****
    //所有的查詢結果
    let searchResult: Observable<GitHubRepositories>
    
    //查詢結果裡的資源列表
    let repositories: Observable<[GitHubRepository]>
    
    //清空結果動作
    let cleanResult: Observable<Void>
    
    //NavigationTitle
    let navigationTitle: Observable<String>
    
    //ViewModel init(根據輸入實現對應的輸出)
    init(searchAction: Observable<String>) {
        self.searchAction = searchAction
        
        //生成結果查詢序列
        self.searchResult = searchAction
            .filter { !$0.isEmpty }
            .flatMapLatest { GitHubManager.shared.searchRepositories(quert: $0) }
            .share(replay: 1)   //讓HTTP請求是被共享的
        
        // 生成清空結果動作Observable
        self.cleanResult = searchAction.filter { $0.isEmpty }
            .map { _ in Void() }
        
        // 生成查詢結果裡的資源列表序列(如果查詢到結果則返回結果，如果是清空數據則返回空Array)
        self.repositories = Observable.of(searchResult.map { $0.items },cleanResult.map { [] })
            .merge()
        
        //生成NavigationTitleObservable(如果查詢到結果則回傳數量，如果沒有則回傳默認Title)
        self.navigationTitle = Observable.of(
            searchResult.map { "共有\($0.totalCount)個結果" },
            cleanResult.map { "首頁" })
            .merge()
    }
}
