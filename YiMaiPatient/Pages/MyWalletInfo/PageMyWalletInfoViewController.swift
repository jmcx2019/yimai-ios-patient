//
//  PageMyWalletInfoViewController.swift
//  YiMaiPatient
//
//  Created by why on 2017/2/6.
//  Copyright © 2017年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageMyWalletInfoViewController: PageViewController {
    var BodyView: PageMyWalletInfoBodyView!

    override func PageLayout() {
        super.PageLayout()

        BodyView = PageMyWalletInfoBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "我的钱包", navController: NavController!)
        DrawTopButton()
    }
    
    func DrawTopButton() {
        let topLabel = YMLayout.GetNomalLabel("明细", textColor: YMColors.FontGray, fontSize: 30.LayoutVal())
        TopView?.TopViewPanel.addSubview(topLabel)
        topLabel.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 25.LayoutVal(), width: topLabel.width, height: topLabel.height)
        
        topLabel.SetTouchable(withObject: BodyView.InfoAction, useMethod: "GoToDetail:".Sel())
    }

    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            BodyView.FullPageLoading.Show()
            BodyView.Clear()
            BodyView.InfoAction.LoadList = true
            BodyView.InfoAction.InfoApi.YMWalletInfo()
        }
    }
    
    override func YMUpdateStateFromWXPay() {
        super.YMUpdateStateFromWXPay()
        BodyView!.FullPageLoading.Show()
        BodyView.InfoAction.InfoApi.YMWalletInfo()
    }
    
    override func YMShowErrorFromWXPay() {
        super.YMShowErrorFromWXPay()
        YMPageModalMessage.ShowErrorInfo("支付失败，请重试！", nav: self.NavController!)
        BodyView.FullPageLoading.Hide()
    }
}




















