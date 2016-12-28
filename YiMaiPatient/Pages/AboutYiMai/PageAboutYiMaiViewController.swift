//
//  PageAboutYiMaiViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageAboutYiMaiViewController: PageViewController {
    private var BodyView: PageAboutYiMaiBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAboutYiMaiBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "关于医者脉连-看专家", navController: self.NavController!)
    }
}
