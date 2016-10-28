//
//  PageSYSBroadcastActions.swift
//  YiMai
//
//  Created by superxing on 16/10/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageSYSBroadcastActions: PageJumpActions {
    var TargetView: PageSYSBroadcastBodyView!
    var BroadcastApi: YMAPIUtility!

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageSYSBroadcastBodyView
        BroadcastApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_SYS_BORADCAST_LIST,
                                    success: GetBroadcastSuccess, error: GetBroadcastError)
    }
    
    func GetBroadcastSuccess(data: NSDictionary?) {
        if(nil == data) {
            return
        }
        let list = data!["data"] as! [[String: AnyObject]]
        
        TargetView.AddMsg(list)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetBroadcastError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView.FullPageLoading.Hide()
    }
    
    func ShowBroadcastDetail(gr: UIGestureRecognizer) {
        let cell = gr.view as! YMTouchableView
        let data = cell.UserObjectData as! [String: AnyObject]
        
        print(data)
        
        PageShowWebViewController.TargetUrl = data["url"] as! String
        DoJump(YMCommonStrings.CS_PAGE_SHOW_WEB_PAGE)
        //TODO: 显示content
    }
}









