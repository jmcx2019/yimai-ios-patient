//
//  PageSYSBroadcastViewController.swift
//  YiMai
//
//  Created by superxing on 16/10/13.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageSYSBroadcastViewController: PageViewController {
    var BodyView: PageSYSBroadcastBodyView!
    
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSYSBroadcastBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "系统广播", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.GetList()
    }
}















