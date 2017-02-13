//
//  PageMyWalletInfoActions.swift
//  YiMaiPatient
//
//  Created by why on 2017/2/6.
//  Copyright © 2017年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageMyWalletInfoActions: PageJumpActions {
    var TargetView: PageMyWalletInfoBodyView!
    var InfoApi: YMAPIUtility!
    var ChargeApi: YMAPIUtility!
    var PayListApi: YMAPIUtility!
    
    var LoadList = true

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageMyWalletInfoBodyView
        
        InfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_USER_WALLET_INFO, success: GetInfoSuccess, error: GetInfoError)
        ChargeApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_RECHARGE_WALLET, success: ChargeSuccess, error: ChargeError)
        PayListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_PAY_FOR_LIST, success: PayForListSuccess, error: PayForListError)
    }
    
    func PayForListSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        var errorStatus = ""
        for ret in realData {
            let status = YMVar.GetStringByKey(ret, key: "status_code")
            if ("200" != status) {
                errorStatus = status
                break
            }
        }
        
        if("400" == errorStatus) {
            YMPageModalMessage.ShowConfirmInfo("余额不足，是否充值？", nav: NavController!, ok: { (_) in
                self.Charge(YMButton())
            }) { (_) in
                self.TargetView.FullPageLoading.Hide()
            }
        } else if("500" == errorStatus) {
            YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
        } else {
            TargetView.HideAppointmentBox()
            YMPageModalMessage.ShowNormalInfo("付款成功！", nav: NavController!)
            TargetView.FullPageLoading.Show()
            
            LoadList = false
            InfoApi.YMWalletInfo()
        }
    }
    
    func PayForListError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        YMAPIUtility.PrintErrorInfo(error)
        
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            //let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            YMAPIUtility.PrintErrorInfo(error)
            if(response.statusCode >= 500) {
                //显示服务器繁忙
                YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
            } else if (400 == response.statusCode) {
                //显示验证失败，用户名或密码错误
                YMPageModalMessage.ShowConfirmInfo("余额不足，是否充值？", nav: NavController!, ok: { (_) in
                    self.Charge(YMButton())
                }) { (_) in
                    self.TargetView.FullPageLoading.Hide()
                }
                //                YMPageModalMessage.ShowErrorInfo("余额不足，请!", nav: self.NavController!)
            } else {
                //显示服务器繁忙
                YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
            }
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
    }
    
    func GoToDetail(_: AnyObject) {
        DoJump(YMCommonStrings.CS_PAGE_WALLET_RECORD)
    }
    
    func ChargeSuccess(data: NSDictionary?) {
        
        let prepayInfo = data!["data"] as! [String: AnyObject]
        let req = PayReq()
        req.openID = "\(prepayInfo["appid"]!)"
        req.partnerId = "\(prepayInfo["partnerid"]!)"
        req.prepayId = "\(prepayInfo["prepayid"]!)"
        req.nonceStr = "\(prepayInfo["noncestr"]!)"
        req.timeStamp = UInt32(NSDate().timeIntervalSince1970)
        req.package = "\(prepayInfo["package"]!)"
        req.sign = "\(prepayInfo["sign"]!)"
        TargetView?.FullPageLoading.Hide()
        WXApi.sendReq(req)
    }
    
    func ChargeError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试。", nav: self.NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetInfoSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [String: AnyObject]
        TargetView.LoadData(realData, loadList: LoadList)
        LoadList = true
        TargetView.FullPageLoading.Hide()
    }
    
    func GetInfoError(data: NSError) {
        LoadList = true
        YMAPIUtility.PrintErrorInfo(data)
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试。", nav: self.NavController!)
        TargetView.FullPageLoading.Hide()
    }
    
    func DoCharge(value: Int) {
        TargetView.FullPageLoading.Show()
        ChargeApi.YMWalletRecharge("\(value)")
    }
    
    func Charge(_: YMButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let charge100 = UIAlertAction(title: "充值100元", style: .Default) { (_) in
            self.DoCharge(100)
        }
        let charge200 = UIAlertAction(title: "充值200元", style: .Default) { (_) in
            self.DoCharge(200)
        }
        let charge300 = UIAlertAction(title: "充值300元", style: .Default) { (_) in
            self.DoCharge(300)
        }
        let charge500 = UIAlertAction(title: "充值500元", style: .Default) { (_) in
            self.DoCharge(500)
        }
        let cancelBtn = UIAlertAction(title: "取消", style: .Cancel) { (_) in
            self.TargetView.FullPageLoading.Hide()
        }
        charge100.setValue(YMColors.PatientFontGreen, forKey: "titleTextColor")
        charge200.setValue(YMColors.PatientFontGreen, forKey: "titleTextColor")
        charge300.setValue(YMColors.PatientFontGreen, forKey: "titleTextColor")
        charge500.setValue(YMColors.PatientFontGreen, forKey: "titleTextColor")
        cancelBtn.setValue(YMColors.FontGray, forKey: "titleTextColor")
        
        alertController.addAction(charge100)
        alertController.addAction(charge200)
        alertController.addAction(charge300)
        alertController.addAction(charge500)
        alertController.addAction(cancelBtn)
        
        NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func GetMoney(sender: YMButton) {
        print("GetMoney touhced")
    }
}






















