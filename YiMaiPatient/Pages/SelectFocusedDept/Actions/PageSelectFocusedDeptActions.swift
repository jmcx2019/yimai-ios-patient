//
//  PageSelectFocusedDeptActions.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/22.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageSelectFocusedDeptActions: PageJumpActions {
    var TargetView: PageSelectFocusedDeptBodyView!
    var GetDeptApi: YMAPIUtility!
    var UpdateTagApi: YMAPIUtility!

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageSelectFocusedDeptBodyView
        GetDeptApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_TAGS_AND_ILLNESS,
                                  success: GetDeptSuccess, error: GetDeptError)
        UpdateTagApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-tag", success: UpdateTagSuccess, error: UpdateTagError)
    }
    
    func GetDeptSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        
        YMLocalData.SaveData(realData, key: "GroupedTagInfo")
//        print(realData.count)
        TargetView.LoadData(realData)
        TargetView.FullPageLoading.Hide()
    }

    func GetDeptError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func TagTouched(gr: UIGestureRecognizer) {
        let tag = gr.view as! YMLabel
        TargetView.SwapTagStatus(tag)
    }
    
    func UpdateTagSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        let realData = data!["data"] as! [String: AnyObject]
        YMVar.MyInfo["tags"] = realData["tags"]
        
        DoJump(YMCommonStrings.CS_PAGE_SELECT_FOCUSED_ILLNESS)
    }
    
    func UpdateTagError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        TargetView.EnableSaveButton()
    }
    
    func SaveSelectedTag(sender: YMButton) {
//        TargetView.FullPageLoading.Show()
//        TargetView.DisableSaveButton()
//        UpdateTagApi.YMChangeUserInfo(["tags": TargetView.GetTaglist()])
    }
    
    func TagSelectNextStep(sender: YMButton) {
        TargetView.FullPageLoading.Show()
        TargetView.DisableSaveButton()
        UpdateTagApi.YMChangeUserInfo(["tags": TargetView.GetTaglist()])
    }
}




