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
    public static var MyInfo: [String:AnyObject]! = [String:AnyObject]()
    public static var DeviceToken: String = ""
    
    public static func Clear() {
        YMVar.MyInfo.removeAll()
        YMVar.MyId = ""
    }
    
    public static func GetStringByKey(dict: [String: AnyObject]?, key: String, defStr: String = "") -> String {
        if(nil == dict) {
            return defStr
        }
        let ret = dict![key]
        if(nil == ret) {
            return defStr
        }
        
        if("<null>" == "\(ret!)") {
            return defStr
        }
        
        let retStr = "\(ret!)"
        if(YMValueValidator.IsBlankString(retStr)) {
            return defStr
        }
        
        return retStr
    }
    
    public static func GetIntStringByKey(dict: [String: AnyObject], key: String) -> String {
        let ret = dict[key] as? Int
        if(nil == ret) {
            return ""
        }
        
        return "\(ret!)"
    }
    
    public static func GetOptionalValAsString(val: AnyObject?) -> String {
        if(nil == val) {
            return ""
        }
        
        let valStr = "\(val!)"
        
        if("<null>" == valStr) {
            return ""
        }
        
        return valStr
    }
    
    static func TryToGetArrayFromJsonStringData(json: String?) -> NSArray? {
        if(nil == json) {
            return nil
        }
        let data = json!.dataUsingEncoding(NSUTF8StringEncoding)
        if(nil == data) { return nil }
        guard let ret = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray else { return nil }
        return ret
    }
    
    static func TryToGetDictFromJsonStringData(json: String?) -> NSDictionary? {
        if(nil == json) {
            return nil
        }
        let data = json!.dataUsingEncoding(NSUTF8StringEncoding)
        if(nil == data) { return nil }
        guard let ret = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary else { return nil }
        return ret
    }
    
    static func TransObjectToString(obj: AnyObject) -> String {
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        return strJson
    }
}










