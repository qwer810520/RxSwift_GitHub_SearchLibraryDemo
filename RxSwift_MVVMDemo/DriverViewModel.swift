//
//  DriverViewModel.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/19.
//  Copyright © 2018年 Min. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DriverViewModel {
    //****輸入部分****
    //查詢行為
    fileprivate let searchAction: Driver<String>
    
    //****輸出部分****
    //所有查詢結果
    let searchResult: Driver<GitHubRepositories>
    
    //查詢結果裡的資源列表
    let repositories: Driver<[GitHubRepository]>
    
    //清空結果動作
    let cleanResult: Driver<Void>
    
    //navigationTitle
    let navigationTitle: Driver<String>
    
    //ViewModelinit(根據輸入實現對應的輸出)
    init(searchAction: Driver<String>) {
        self.searchAction = searchAction
        
        //生成查詢結果序列
        self.searchResult = searchAction
            .filter { !$0.isEmpty }
            .flatMapLatest {
                GitHubManager.shared
                    .searchRepositoriesForDriver(query: $0)
            }
        
        //生成清空結果動作序列
        self.cleanResult = searchAction
            .filter { $0.isEmpty }
            .map { _ in Void() }
        
        //生成查詢結果裡的資源列表(如果查詢到結果則回傳結果，如果是清空數據格回傳空Array)
        self.repositories = Driver.merge(
            searchResult.map { $0.items },
            cleanResult.map { [] }
        )
        
        //生成NavigationTitleObservable(如果查詢到結果則返回數量，如果是清空數據則回傳默認標題)
        self.navigationTitle = Driver.merge(
            searchResult.map { "共有\($0.totalCount)個結果" },
            cleanResult.map { "首頁" }
        )
    }
}
