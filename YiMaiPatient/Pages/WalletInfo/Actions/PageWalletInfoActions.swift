//
//  PageWalletInfoActions.swift
//  YiMaiPatient
//
//  Created by old-king on 16/11/15.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

class PageWalletInfoActions: PageJumpActions {
    override func ExtInit() {
        super.ExtInit()
    }
    
    func ShowPayError(gr: UIGestureRecognizer) {
        YMPageModalMessage.ShowErrorInfo("网络连接失败，请稍后再进行充值操作。", nav: self.NavController!)
    }
    
    func ShowOutError(gr: UIGestureRecognizer) {
        YMPageModalMessage.ShowErrorInfo("网络连接失败，请稍后重试。", nav: self.NavController!)
    }
}






