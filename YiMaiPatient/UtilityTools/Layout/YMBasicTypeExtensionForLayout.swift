//
//  YMBasicTypeExtensionForLayout.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    public func LayoutVal() -> CGFloat {
        return self / YMSizes.GetScaleRatio()
    }
    
    public func LayoutImgVal() -> CGFloat {
        return self * YMSizes.GetScaleRatioInPixel()
    }
}

extension Double {
    public func LayoutVal() -> CGFloat {
        return CGFloat(self) / YMSizes.GetScaleRatio()
    }
    
    public func LayoutImgVal() -> CGFloat {
        return CGFloat(self) * YMSizes.GetScaleRatioInPixel()
    }
}

extension Int {
    public func LayoutVal() -> CGFloat {
        return CGFloat(self) / YMSizes.GetScaleRatio()
    }
    
    public func RGBVal() -> CGFloat {
        return CGFloat(self) / 255
    }
}

extension String {
    public func Sel() -> Selector {
        return Selector(self)
    }
}