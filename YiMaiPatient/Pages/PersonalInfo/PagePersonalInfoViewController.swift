//
//  PagePersonalInfoViewController.swift
//  YiMaiPatient
//
//  Created by superxing on 16/10/24.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

class PagePersonalInfoViewController: PageViewController {
    var BodyView: PagePersonalInfoBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PagePersonalInfoBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "我的账户", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        YMLayout.ClearView(view: self.view)
        
        BodyView.Actions = nil
        BodyView.InfoActions.TargetView = nil
        BodyView.InfoActions = nil
        
        BodyView = PagePersonalInfoBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "我的账户", navController: self.NavController!)
    }
}
