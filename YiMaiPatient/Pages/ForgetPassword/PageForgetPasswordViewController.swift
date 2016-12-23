//
//  PageForgetPasswordViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageForgetPasswordViewController: PageViewController {
    public var BodyView: PageForgetPasswordBodyView? = nil
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageForgetPasswordBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "重置密码", navController: self.NavController!)
    }
    
    override func PageDisapeared() {
        BodyView?.Clear()
    }
}
