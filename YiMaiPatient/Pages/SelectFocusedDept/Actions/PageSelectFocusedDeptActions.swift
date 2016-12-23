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

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageSelectFocusedDeptBodyView
        GetDeptApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_TAGS_AND_ILLNESS,
                                  success: GetDeptSuccess, error: GetDeptError)
    }
    
    func GetDeptSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        
        YMLocalData.SaveData(realData, key: "GroupedTagInfo")
        print(realData.count)
        TargetView.LoadData(realData)
        TargetView.FullPageLoading.Hide()

    }

    func GetDeptError(error: NSError) {
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!)
        YMAPIUtility.PrintErrorInfo(error)
    }
}




