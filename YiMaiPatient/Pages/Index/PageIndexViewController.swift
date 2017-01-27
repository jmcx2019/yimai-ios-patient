//
//  PageIndexViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit
import Neon

public class PageIndexViewController: PageViewController {
    public var BodyView: PageIndexBodyView? = nil
    static var IsFromLogin = false
    
    override func PageLayout() {
        super.PageLayout()
//        BodyView = PageIndexBodyView(parentView: self.SelfView!, navController: self.NavController!)
//        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "")
//
//        BodyView?.DrawTopBtn(TopView!.TopViewPanel)
//        BodyView?.DrawSideBar()
        
    }
    
    override func PagePreRefresh() {
        super.PagePreRefresh()
        YMCurrentPage.CurrentPage = YMCommonStrings.CS_PAGE_INDEX_NAME

        if(PageIndexViewController.IsFromLogin) {
            YMLayout.ClearView(view: self.view)

            BodyView = PageIndexBodyView(parentView: self.SelfView!, navController: self.NavController!)
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "")
            
            BodyView?.DrawTopBtn(TopView!.TopViewPanel)
            BodyView?.DrawSideBar()
            
            BodyView?.DrawMsgPanel()
            PageIndexViewController.IsFromLogin = false

            print("get banner start")
            BodyView?.IndexActions?.BannerApi?.YMGetIndexBanner()
            UpdateDeviceToken()
            YMBackgroundRefresh.Start()
            YMBackgroundRefresh.RegisterCallback(YMBackgroundCallbackFor.SystemMessage, cb: BodyView!.RefreshMessagePanel)
        } else {
            BodyView?.Refresh()
        }
    }
    
    func UpdateDeviceToken() {
        if(YMVar.DeviceToken.characters.count != 64) {
            YMDelay(1.0, closure: {
                self.UpdateDeviceToken()
            })
            return
        }
        BodyView?.IndexActions?.UpdateDeviceToken.YMChangeUserInfo(["device_token": YMVar.DeviceToken])
    }
}










