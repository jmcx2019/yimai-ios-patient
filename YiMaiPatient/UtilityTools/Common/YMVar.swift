//
//  YMVar.swift
//  YiMai
//
//  Created by why on 16/6/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public class YMVar:NSObject {
    public static var MyId: String = ""
    public static var MyInfo: [String:AnyObject]!
    
    public static func GetStringByKey(dict: [String: AnyObject], key: String) -> String {
        let ret = dict[key] as? String
        if(nil == ret) {
            return ""
        }
        
        return ret!
    }
    
    public static func GetIntStringByKey(dict: [String: AnyObject], key: String) -> String {
        let ret = dict[key] as? Int
        if(nil == ret) {
            return ""
        }
        
        return "\(ret!)"
    }
}