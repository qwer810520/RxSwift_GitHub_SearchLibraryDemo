//
//  GitHubManager.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/17.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubManager {
    
    static let shared = GitHubManager()
    
    func searchRepositories(quert: String) -> Observable<GitHubRepositories> {
        return GitHubProvider.rx.request(.repositories(quert))
            .filterSuccessfulStatusCodes()
            .mapObject(typr: GitHubRepositories.self)
            .asObservable()
            .catchError({ (error) in
                print("發生錯誤", error.localizedDescription)
                return Observable<GitHubRepositories>.empty()
            })
    }
    
    func searchRepositoriesForDriver(query: String) -> Driver<GitHubRepositories> {
        return GitHubProvider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .mapObject(typr: GitHubRepositories.self)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
