//
//  YMFonts.swift
//  YiMai
//
//  Created by why on 16/4/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class YMFonts {
    public static func YMDefaultFont(fontSize: CGFloat) -> UIFont? {
        let font = YMFonts.GetDefaultFont(fontSize)
        
        if(nil == font){
            return UIFont.systemFontOfSize(fontSize)
        } else {
            return font
        }
    }
    
    private static func GetDefaultFont(fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "FZLTXHK--GBK1-0", size: fontSize)
    }
}