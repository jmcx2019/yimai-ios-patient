//
//  PageSearchDefaultViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/9/11.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

class PageSearchDefaultViewController: PageViewController {
    var BodyView: PageSearchDefaultBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSearchDefaultBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "搜索", navController: self.NavController!)
    }
    
    override func PageDisapeared() {
        BodyView?.Clear()
    }
    
    override func PageRefresh() {
        BodyView?.LoadingView?.Show()
        BodyView?.SearchActions?.GetDefaultSearch()
    }
}
