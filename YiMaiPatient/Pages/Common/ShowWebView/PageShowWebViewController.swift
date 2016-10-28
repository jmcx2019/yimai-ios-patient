
//
//  PageShowWebViewController.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/10/15.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageShowWebViewController: PageViewController {
    var BodyView: PageShowWebBodyView!
    static var TargetUrl = "/"
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageShowWebBodyView(parentView: self.view,
                                       navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view,
                                    titleString: "浏览",
                                    navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.Clear()
        let urlStr = YMAPIInterfaceURL.Server +
            PageShowWebViewController.TargetUrl
        
        BodyView.LoadWebPage(urlStr)
    }
    
    override func PageDisapeared() {
        BodyView.Clear()
        PageShowWebViewController.TargetUrl = "/"
    }
}






