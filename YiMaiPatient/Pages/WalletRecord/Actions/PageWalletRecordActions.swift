//
//  PageWalletRecordActions.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/15.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageWalletRecordActions: PageJumpActions {
    var TargetView: PageWalletRecordBodyView!
    var ListApi: YMAPIUtility!

    override func ExtInit() {
        TargetView = Target as! PageWalletRecordBodyView
        ListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_USER_WALLET_RECORD, success: GetListSuccess, error: GetListError)
    }
    
    func GetListSuccess(data: NSDictionary?) {
        print(data)
        TargetView.LoadData(data!["data"] as! [[String: AnyObject]])
        TargetView.FullPageLoading.Hide()
    }
    
    func GetListError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: self.NavController!)
    }
}






