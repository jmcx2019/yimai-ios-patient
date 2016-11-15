//
//  PageLoginActions.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

public class PageLoginActions: PageJumpActions {
    
    private var PageLoginBody: PageLoginBodyView? = nil
    private var LoginSuccessTargetStroyboard: String = ""
    private let LoginActionKey = "YMLoginAction"
    private var ApiUtility : YMAPIUtility? = nil

    private func VarSet(sender: YMButton) {
        if(nil == self.ApiUtility) {
            self.ApiUtility = YMAPIUtility(key: self.LoginActionKey)
        }
        
        if(nil == self.PageLoginBody) {
            self.PageLoginBody = self.Target as? PageLoginBodyView
        }
        
        if("" == self.LoginSuccessTargetStroyboard) {
            self.LoginSuccessTargetStroyboard = sender.UserStringData
        }
    }
    
    public func LoginSuccessCallback(data: NSDictionary?) {
        let realData = data!
        let userInfo = self.PageLoginBody?.GetUserInputInfo()
        
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_TOKEN, data: realData["token"]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_ORG_PASSWORD, data: userInfo!["password"]!)
        YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA).YMGetAPPInitData()
//        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS, data: true)
        
        let handler = YMCoreMemDataOnceHandler(handler: LoginSuccess)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_MY_ACCOUNT_SETTING, handler: handler)
        
        YMLocalData.SaveLogin(userInfo!["phone"]!, pwd: userInfo!["password"]!)
    }
    
    private func LoginSuccess(_: AnyObject?, queue: NSOperationQueue) -> Bool {
        let loginStatus = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS) as? Bool
        
        if(nil == loginStatus) {
            return false
        }
        
        let unpackedStatus = loginStatus!
        if(!unpackedStatus) {
            queue.addOperationWithBlock({ () -> Void in
                YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
                self.PageLoginBody?.EnableLoginControls()
            })
        } else {
            queue.addOperationWithBlock({ () -> Void in
                PageIndexViewController.IsFromLogin = true
                self.PageLoginBody?.ClearLoginControls()
                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
            })
        }
        
        return true
    }
    
    public func LoginErrorCallback(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            //let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            
            if(response.statusCode >= 500) {
                //显示服务器繁忙
                self.PageLoginBody?.ShowErrorInfo("服务器繁忙，请稍后再试。")
            } else if (response.statusCode >= 400) {
                //显示验证失败，用户名或密码错误
                self.PageLoginBody?.ShowErrorInfo("手机号或密码错误！")
            } else {
                //显示服务器繁忙
                self.PageLoginBody?.ShowErrorInfo("服务器繁忙，请稍后再试。")
            }
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        
        
        self.PageLoginBody?.EnableLoginControls()
    }
    
    public func DoLogin(sender:YMButton) {
        if(nil == self.NavController){return}
        VarSet(sender)
        
        let userInfo = self.PageLoginBody?.GetUserInputInfo()
        if(nil == userInfo) {return}
        
        YMAPICommonVariable.SetJsonCallback(self.LoginActionKey, callback: self.LoginSuccessCallback, update: false)
        YMAPICommonVariable.SetErrorCallback(self.LoginActionKey, callback: self.LoginErrorCallback, update: false)
        
        self.PageLoginBody?.DisableLoginControls()
        self.ApiUtility?.YMUserLogin(userInfo!, progressHandler: nil)
    }
}