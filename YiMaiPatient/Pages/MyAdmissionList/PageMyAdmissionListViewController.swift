//
//  PageMyAdmissionListViewController.swift
//  YiMai
//
//  Created by superxing on 16/11/23.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

class PageMyAdmissionListViewController: PageViewController {
    var BodyView: PageMyAdmissionListBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageMyAdmissionListBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "我的约诊消息", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            YMLayout.ClearView(view: BodyView.BodyView)
            BodyView.FullPageLoading.Show()
            BodyView.ListActions.GetListApi.YMGetAllMessage()
        }
    }
}
