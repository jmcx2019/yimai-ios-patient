//
//  YMSizes.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class YMSizes {
    private static var ScaleRatioCalced = false
    private static var RatioInPixelCalced = false
    
    public static let MainScreen = UIScreen.mainScreen()
    
    public static var ScaleRatio : CGFloat = 0.0
    public static var ScaleRatioInPixel : CGFloat = 0.0
    
    public static var ScreenWidth : CGFloat = UIScreen.mainScreen().bounds.width
    public static var PageWidth : CGFloat = UIScreen.mainScreen().bounds.width
    public static var PageHeight : CGFloat = UIScreen.mainScreen().bounds.height
    public static let DesignedWidth : CGFloat = 750.0
    public static let PageTopHeight : CGFloat = 128.0.LayoutVal()
    public static let PageBottomHeight : CGFloat = 98.0.LayoutVal()
    public static let PageTopTitleFontSize : CGFloat = 40.LayoutVal()
    
    public static let PageNormalInputFontSize : CGFloat = 28.LayoutVal()
    public static let PageScrollBodyInsetOnlyTop : UIEdgeInsets = UIEdgeInsets(top: 128.LayoutVal(), left: 0, bottom: 0, right: 0)
    public static let PageScrollBodyInsetOnlyBottom : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 98.LayoutVal(), right: 0)
    public static let PageScrollBodyInset : UIEdgeInsets = UIEdgeInsets(top: 128.LayoutVal(), left: 0, bottom: 98.LayoutVal(), right: 0)
    
    public static let PagePersonalTopHeight = 510.LayoutVal()
    
    public static let CommonTouchableViewHeight = 81.LayoutVal()
    public static let CommonLargeTouchableViewHeight = 141.LayoutVal()
    
    public static let OnPx = 1 / YMSizes.MainScreen.scale


    public static let NormalTopSize : CGRect = CGRect(x: 0, y: 0, width: YMSizes.PageWidth, height: YMSizes.PageTopHeight)
    public static let NormalBottomSize : CGRect = CGRect(x: 0, y: 0, width: YMSizes.PageWidth, height: YMSizes.PageBottomHeight)
    
    init(){
    }
    
    public static func GetScaleRatio() -> CGFloat {
        
        if(false == YMSizes.ScaleRatioCalced){
            YMSizes.ScaleRatio = YMSizes.DesignedWidth / YMSizes.PageWidth
            YMSizes.ScaleRatioCalced = true
        }
        
        return YMSizes.ScaleRatio
    }
    
    public static func GetScaleRatioInPixel() -> CGFloat {

        if(false == YMSizes.RatioInPixelCalced){
            let mainScreenWidth = YMSizes.PageWidth
            let mainScreenPixelWidth = mainScreenWidth * YMSizes.MainScreen.scale
            YMSizes.ScaleRatioInPixel = mainScreenPixelWidth / YMSizes.DesignedWidth
            YMSizes.RatioInPixelCalced = true
        }

        return YMSizes.ScaleRatioInPixel
    }
}