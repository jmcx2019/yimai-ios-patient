
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
    static var IsFromDoctorServer = false
    static var TitleString = "浏览"
    
    override func PageLayout() {
        super.PageLayout()
    }
    
    override func PagePreRefresh() {
        YMLayout.ClearView(view: self.view)
        
        BodyView = PageShowWebBodyView(parentView: self.view,
                                       navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view,
                                    titleString: PageShowWebViewController.TitleString,
                                    navController: self.NavController!)
        BodyView.Clear()
        var urlStr = ""
        if(PageShowWebViewController.TargetUrl.containsString("http")) {
            urlStr = PageShowWebViewController.TargetUrl
        } else if (PageShowWebViewController.IsFromDoctorServer) {
            urlStr = YMAPIInterfaceURL.DoctorServer +
                PageShowWebViewController.TargetUrl
        } else {
            urlStr = YMAPIInterfaceURL.Server +
                PageShowWebViewController.TargetUrl
        }
        
        BodyView.LoadWebPage(urlStr)
    }
    
    override func PageDisapeared() {
        PageShowWebViewController.TargetUrl = "/"
        PageShowWebViewController.TitleString = "浏览"
        PageShowWebViewController.IsFromDoctorServer = false
        BodyView.Clear()
    }
}






