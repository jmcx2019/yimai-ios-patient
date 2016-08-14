//
//  YMLoaclData.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Graph

public class YMLocalData {
    private static let Engine = Graph()
    
    public static func SaveLogin(user: String, pwd: String) {
        let e = Entity(type: YMLocalDataStrings.EN_LOGIN_INFO)
        e[YMCoreDataKeyStrings.KEY_LOGIN_NAME] = user
        e[YMCoreDataKeyStrings.KEY_PASSWORD] = pwd
        YMLocalData.Engine.save()
    }
    
    public static func ClearLogin() {
        let es = YMLocalData.Engine.searchForEntity(types: [YMLocalDataStrings.EN_LOGIN_INFO])
        
        for v in es {
            v.delete()
        }
        
        YMLocalData.Engine.save()
    }
    
    public static func GetLoginInfo() -> Entity? {
        let es = YMLocalData.Engine.searchForEntity(types: [YMLocalDataStrings.EN_LOGIN_INFO])
        if(0 == es.count) {
            return nil
        }
        
        return es[0]
    }
    
    public static func SavePrivateInfo(key: String, data: Bool) {
        let login = YMLocalData.GetLoginInfo()
        if(nil == login) {
            return
        }
        let user = login![YMCoreDataKeyStrings.KEY_LOGIN_NAME] as! String

        let privateInfo = YMLocalData.GetPrivateInfo()
        if(nil == privateInfo) {
            let e = Entity(type: "\(user).private")
            e[key] = data
        } else {
            privateInfo![key] = data
        }
        
        
        YMLocalData.Engine.save()
    }
    
    public static func GetPrivateInfo() -> Entity? {
        let login = YMLocalData.GetLoginInfo()
        if(nil == login) {
            return nil
        }
        
        let user = login![YMCoreDataKeyStrings.KEY_LOGIN_NAME] as! String
        let privateInfo = YMLocalData.Engine.searchForEntity(types: ["\(user).private"])
        
        if(0 == privateInfo.count) {
            return nil
        }
        
        return privateInfo[0]
    }
}















