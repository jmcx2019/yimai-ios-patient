//
//  PageMyAdmissionListViewController.swift
//  YiMai
//
//  Created by superxing on 16/11/23.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit
import Neon

class PageMyAdmissionListViewController: PageViewController {
    var BodyView: PageMyAdmissionListBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageMyAdmissionListBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "我的约诊消息", navController: self.NavController!)
        DrawClearAllReadFlag()
    }
    
    func DrawClearAllReadFlag() {
        let btn = YMLayout.GetNomalLabel("全部设为已读", textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        TopView?.TopViewPanel.addSubview(btn)
        
        btn.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 26.LayoutVal(), width: btn.width, height: btn.height)
        btn.SetTouchable(withObject: BodyView.ListActions, useMethod: "SetAllReaden:".Sel())
    }
    
    override func PagePreRefresh() {
        if(self.isMovingToParentViewController()) {
            YMLayout.ClearView(view: BodyView.BodyView)
            BodyView.FullPageLoading.Show()
        }
        
        BodyView.ListActions.GetListApi.YMGetAllMessage()
    }
}
