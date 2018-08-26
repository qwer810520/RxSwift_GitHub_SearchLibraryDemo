//
//  GitHubAPI.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/14.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import Moya

//初始化GitHub請求的provider
let GitHubProvider = MoyaProvider<GitHubAPI>()

//下面定義GitHub請求的endpoints(供Provider使用)
//請求分類
public enum GitHubAPI {
    case repositories(String)       //查詢資料庫
}

//請求配置
extension GitHubAPI: TargetType {
    
    //ServerIP
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    //請求的具體路徑
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    //請求類型
    public var method: Moya.Method {
        return .get
    }
    
    //這是在做單元測試模擬的數據，只會在單元測試中有作用
    public var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    //request所帶的參數
    public var task: Task {
        switch self {
        case .repositories(let quary):
            var paramaters = [String: Any]()
            paramaters["q"] = quary
            paramaters["sort"] = "stars"
            paramaters["order"] = "desc"
            return .requestParameters(parameters: paramaters, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

