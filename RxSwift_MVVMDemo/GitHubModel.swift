//
//  GitHubModel.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/14.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit

public protocol ParentModel {
    init(json: [String: Any])
}

struct GitHubRepositories: ParentModel {
    var totalCount: Int
    var incompleteResults: Bool
    var items: [GitHubRepository]
    
    init(json: [String : Any]) {
        self.totalCount = (json["total_count"] as? Int) ?? 0
        self.incompleteResults = (json["incomplete_results"] as? Bool) ?? false
        guard let itemList = json["items"] as? [[String: Any]] else {
            self.items = [GitHubRepository]()
            return
        }
        var data = [GitHubRepository]()
        itemList.forEach { data.append(GitHubRepository(json: $0)) }
        self.items = data
    }
}

struct GitHubRepository: ParentModel {
    var id: Int
    var name: String
    var fullName: String
    var htmlURL: String
    var description: String
    
    init(json: [String : Any]) {
        self.id = (json["id"] as? Int) ?? 0
        self.name = (json["name"] as? String) ?? ""
        self.fullName = (json["full_name"] as? String) ?? ""
        self.htmlURL = (json["html_url"] as? String) ?? ""
        self.description = (json["description"] as? String) ?? ""
    }
}
