//
//  PageForgetPasswordActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageForgetPasswordActions: PageJumpActions {
    private var GetVerifyApi: YMAPIUtility? = nil
    private var GetPassowrdBackApi: YMAPIUtility? = nil
    private var TargetView: PageForgetPasswordBodyView? = nil
    public var VerifyCodeEnableCounter:Int = 0

    override func ExtInit() {
        super.ExtInit()
        TargetView = self.Target as? PageForgetPasswordBodyView
        GetVerifyApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_FORGET_VERIFY_CODE,
                                    success: self.GetVerifyCodeSuccess,
                                    error: self.GetVerifyCodeError)
        
        GetPassowrdBackApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_PASSWORD_BACK,
                                    success: self.GetPasswordSuccess,
                                    error: self.GetPasswordError)
    }
    
    private func GetPasswordSuccess(_: NSDictionary?){
        TargetView?.Loading?.Hide()
        self.NavController?.popViewControllerAnimated(true)
    }
    
    private func GetPasswordError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            //let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            
            if(response.statusCode >= 500) {
                //显示服务器繁忙
                YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
            } else if (response.statusCode >= 400) {
                //显示验证失败，用户名或密码错误
                YMPageModalMessage.ShowErrorInfo("手机号或密码不符合要求!", nav: self.NavController!)
            } else {
                //显示服务器繁忙
                YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
            }
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        
        TargetView?.Loading?.Hide()
    }
    
    private func GetVerifyCodeError(error: NSError){
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        YMPageModalMessage.ShowErrorInfo("\(errInfo["message"])", nav: self.NavController!)
    }
    
    private func GetVerifyCodeSuccess(data: NSDictionary?) {
        let realData = data! as! [String: AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_FORGET_VERIFY_CODE, data: realData["debug"]!)
        
        //TODO: this is a debug line
        TargetView!.VerifyInput?.text = "\(realData["debug"]!)"
        CheckOnInputChanged(TargetView!.VerifyInput!)
    }
    
    public func VerifyCodeHandler(data: AnyObject?, queue:NSOperationQueue) -> Bool {
        self.VerifyCodeEnableCounter = self.VerifyCodeEnableCounter + 1
        if(0 == self.VerifyCodeEnableCounter % 10) {
            queue.addOperationWithBlock({
                let title = "重新获取(\(60 - self.VerifyCodeEnableCounter/10))"
                self.TargetView!.GetVerifyCodeButton?.setTitle(title, forState: UIControlState.Disabled)
            })
        }
        
        if(600 < self.VerifyCodeEnableCounter) {
            queue.addOperationWithBlock({
                self.TargetView!.GetVerifyCodeButton?.setTitle("", forState: UIControlState.Disabled)
                self.TargetView!.EnableGetVerifyCodeButton()
                self.VerifyCodeEnableCounter = 0
            })
            return true
        }
        return false
    }
    
    public func GetVerifyCode(sender: YMButton) {
        let data = TargetView?.VerifyPhoneBeforeGetCode()
        if(nil == data){return}
        GetVerifyApi?.YMGetVerifyCode(data!)
        self.TargetView!.DisableGetVerifyCodeButton()
        let dataHandler = YMCoreMemDataOnceHandler(handler: self.VerifyCodeHandler)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_FORGET_VERIFY_CODE, handler: dataHandler)
    }
    
    public func CheckOnInputChanged(_: YMTextField) {
        let input = TargetView?.VerifyUserInput()
        if(nil != input) {
            TargetView?.SubmitButton?.enabled = true
        } else {
            TargetView?.SubmitButton?.enabled = false
        }
    }
    
    public func GetPasswordBackSubmit(_: YMButton) {
        let input = TargetView?.VerifyUserInput(true)
        if(nil == input) {
            return
        }
        
        TargetView?.Loading?.Show()
        GetPassowrdBackApi?.YMGetUserPasswordBack(input!)
    }
}












