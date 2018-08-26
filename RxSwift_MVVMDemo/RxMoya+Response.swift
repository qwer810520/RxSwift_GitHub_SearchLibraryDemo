//
//  RxMoya+Response.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/16.
//  Copyright © 2018年 Min. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Response {
    public func asDictionary() throws -> [String: Any] {
        guard let object = try? mapJSON() else {
            throw MoyaError.jsonMapping(self)
        }
        guard let responseData = object as? [String: Any] else {
            throw RxObjectError.asDictionaryError
        }
        return responseData
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapObject<T: ParentModel>(typr: T.Type) -> Single<T> {
        return flatMap({ (response) -> Single<T> in
            guard let responseData = try? response.asDictionary() else {
                throw RxObjectError.asDictionaryError
            }
            
            return Single.just(T(json: responseData))
        })
    }
    
    public func mapObject<T: ParentModel>(type: T.Type, atKeyPath key: String) -> Single<T> {
        return flatMap({ (response) -> Single<T> in
            guard let responseData = try? response.asDictionary() else {
                throw RxObjectError.asDictionaryError
            }
            
            guard let data = responseData[key] as? [String: Any] else {
                throw RxObjectError.mapObjectError
            }
            
            return Single.just(T(json: data))
        })
    }
    
    public func mapArray<T: ParentModel>(type: T.Type, asKeyPath key: String) -> Single<[T]> {
        return flatMap({ (response) -> Single<[T]> in
            guard let responseData = try? response.asDictionary() else {
                throw RxObjectError.asDictionaryError
            }
            
            guard let responseDataList = responseData[key] as? [[String: Any]] else {
                throw RxObjectError.mapArrayError
            }
            var dataList = [T]()
            responseDataList.forEach { dataList.append(T(json: $0)) }
            return Single.just(dataList)
        })
    }
}
