//
//  PageRegisterActions.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageRegisterActions: PageJumpActions {
    private var TargetBodyView : PageRegisterBodyView? = nil
    private var GetVerifyApi: YMAPIUtility? = nil
    private var DoRegisterApi: YMAPIUtility? = nil
    private var VerifyCodeEnableCounter:Int = 0
    override func ExtInit() {
        GetVerifyApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_VERIFY_CODE,
                                    success: self.GetVerifyCodeSuccess,
                                    error: self.GetVerifyCodeError)
        
        DoRegisterApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_DO_REGISTER,
                                     success: self.DoRegisterSuccess,
                                     error: self.DoRegisterError)
        
        TargetBodyView = self.Target as? PageRegisterBodyView
    }
    
    private func GetVerifyCodeError(error: NSError){
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        YMPageModalMessage.ShowErrorInfo("\(errInfo["message"])", nav: self.NavController!)
    }
    
    private func GetVerifyCodeSuccess(data: NSDictionary?) {
        let realData = data! as! [String: AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_REG_VERIFY_CODE, data: realData["debug"]!)
        
        //TODO: this is a debug line
        TargetBodyView!.VerifyCodeInput?.text = "\(realData["debug"]!)"
        
        CheckWhenInputChanged(TargetBodyView!.VerifyCodeInput!)
    }
    
    private func DoRegisterError(error: NSError){
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        
        let errMsg = errInfo.dictionary
        if(nil != errMsg) {
            let errMsgString = errMsg!["message"]
            if(nil != errMsgString) {
                YMPageModalMessage.ShowErrorInfo("\(errMsgString!)", nav: self.NavController!)
            }
        }
        
        self.VerifyCodeEnableCounter = 601
    }
    
    private func DoRegisterSuccess(data: NSDictionary?) {
        let realData = data! as! [String: AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_TOKEN, data: realData["token"]!)
        
        let input = TargetBodyView?.VerifyInput()
        
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_ORG_PASSWORD, data: input!["password"]!)
        YMLocalData.SaveLogin(input!["phone"]!, pwd: input!["password"]!)
        DoJump(YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME)
    }
    
    public func AgreementButtonTouched(sender: YMButton) {
        TargetBodyView?.ToggleAgreementStatus()
        CheckWhenInputChanged(TargetBodyView!.VerifyCodeInput!)
    }
    
    public func AgreementImageTouched(sender: UITapGestureRecognizer) {
        TargetBodyView?.ToggleAgreementStatus()
        CheckWhenInputChanged(TargetBodyView!.VerifyCodeInput!)
    }
    
    public func NextStep(sender: YMButton) {
        let input = TargetBodyView?.VerifyInput()
        if(nil != input){
            DoRegisterApi?.RegisterUser(input!, progressHandler: nil)
        }
    }
    
    public func VerifyCodeHandler(data: AnyObject?, queue:NSOperationQueue) -> Bool {
        self.VerifyCodeEnableCounter = self.VerifyCodeEnableCounter + 1
        if(0 == self.VerifyCodeEnableCounter % 10) {
            queue.addOperationWithBlock({
                let title = "重新获取(\(60 - self.VerifyCodeEnableCounter/10))"
                self.TargetBodyView!.GetVerifyCodeButton?.setTitle(title, forState: UIControlState.Disabled)
            })
        }
        
        if(600 < self.VerifyCodeEnableCounter) {
            queue.addOperationWithBlock({
                self.TargetBodyView!.GetVerifyCodeButton?.setTitle("", forState: UIControlState.Disabled)
                self.TargetBodyView!.EnableGetVerifyCodeButton()
                self.VerifyCodeEnableCounter = 0
            })
            return true
        }
        return false
    }
    
    public func GetVerifyCode(sender: YMButton) {
        let data = TargetBodyView?.VerifyPhoneBeforeGetCode()
        if(nil == data){return}
        GetVerifyApi?.YMGetVerifyCode(data!)
        self.TargetBodyView!.DisableGetVerifyCodeButton()
        let dataHandler = YMCoreMemDataOnceHandler(handler: self.VerifyCodeHandler)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_REG_VERIFY_CODE, handler: dataHandler)
    }
    
    public func CheckWhenInputChanged(_: YMTextField) {
        let ret = TargetBodyView?.VerifyInput(false)
        
        if(nil != ret) {
            TargetBodyView?.NextStepCodeButton?.enabled = true
        } else {
            TargetBodyView?.NextStepCodeButton?.enabled = false
        }
    }
}