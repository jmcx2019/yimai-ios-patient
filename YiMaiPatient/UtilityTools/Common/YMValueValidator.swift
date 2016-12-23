//
//  YMValueValidator.swift
//  YiMai
//
//  Created by why on 16/5/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

public class YMValueValidator {
    private static let MaxCellPhoneNum: Int64 = 20000000000
    private static let MinCellPhoneNum: Int64 = 10000000000

    public static func IsCellPhoneNum(str: String) -> Bool {
        let phoneNum = Int64(str)
        return (phoneNum < MaxCellPhoneNum && phoneNum > MinCellPhoneNum)
    }
    
    public static func IsEmptyString(str: String?) -> Bool {
        return ("" == str) || (nil == str)
    }
    
    public static func IsBlankString(str: String?) -> Bool {
        if(nil == str) {
            return true
        }

        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let cleanStr = str!.stringByTrimmingCharactersInSet(whitespace)
        return YMValueValidator.IsEmptyString(cleanStr)
    }
}