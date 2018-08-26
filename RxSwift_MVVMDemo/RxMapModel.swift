//
//  RxMapModel.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/14.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import RxSwift

public enum RxObjectError: Error {
    case asDictionaryError
    case mapArrayError
    case mapObjectError
    case mapDictionaryError
}

public extension Observable where Element: Any {
    
    // 將Json轉換成Array
    public func mapArray<T>(key: String, model: T.Type) -> Observable<[T]> where T: ParentModel {
        return self.map({ (element) -> [T] in
            guard let responseData = element as? [String: Any] else {
                throw RxObjectError.asDictionaryError
            }
            
            guard let responseDataList = responseData[key] as? [[String: Any]] else {
                throw RxObjectError.mapArrayError
            }
            var dataList = [T]()
            responseDataList.forEach { dataList.append(T(json: $0)) }
            return dataList
        })
    }
    
    // 將JSON轉換成單一Model
    public func mapObject<T>(key: String, model: T.Type) -> Observable<T> where T: ParentModel {
        return self.map({ (element) -> T in
            guard let responseData = element as? [String: Any] else {
                throw RxObjectError.asDictionaryError
            }
            
            guard let data = responseData[key] as? [String: Any] else {
                throw RxObjectError.mapObjectError
            }
            
            return T(json: data)
        })
    }
    
    //將JSON解包
    public func mapDictionary(key: String) -> Observable<Any> {
        return self.map({ (element) -> Any in
            guard let responseData = element as? [String: Any] else {
                throw RxObjectError.asDictionaryError
            }
            
            guard let data = responseData[key] else {
                throw RxObjectError.mapDictionaryError
            }
            
            return data
        })
    }
}
