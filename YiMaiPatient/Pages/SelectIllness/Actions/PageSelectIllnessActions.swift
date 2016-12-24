//
//  PageSelectIllnessActions.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/24.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageSelectIllnessActions: PageJumpActions {
    var TargetView: PageSelectIllnessBodyView!
    var UpdateTagApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageSelectIllnessBodyView
        UpdateTagApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-illness", success: UpadteSuccess, error: UpdateError)
    }
    
    func UpadteSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [String: AnyObject]
        
        YMVar.MyInfo["tags"] = realData["tags"]
        print(realData)
        TargetView.FullPageLoading.Hide()
        DoJump(PageSelectIllnessViewController.WichPageJumpTo)
    }
    
    func UpdateError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        YMAPIUtility.PrintErrorInfo(error)
    }

    func TagSave(sender: YMButton) {
        TargetView.FullPageLoading.Show()
        let newTagInfo = TargetView.GetTagListToSave()
        UpdateTagApi.YMChangeUserInfo(["tags": newTagInfo])
    }
    
    func TagTouched(gr: UIGestureRecognizer) {
        let tag = gr.view as! YMLabel
        
        TargetView.SwapTagStatus(tag)
    }
}













