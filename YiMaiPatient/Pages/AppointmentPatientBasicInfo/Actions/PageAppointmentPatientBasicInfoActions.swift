//
//  PageAppointmentPatientBasicInfoActions.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentPatientBasicInfoActions: PageJumpActions {
    public func BasicInfoDone(sender: UIGestureRecognizer) {
        let pageController = self.Target! as! PageAppointmentPatientBasicInfoViewController
        
        let info = pageController.BodyView!.GetPatientInfo()
        
        let name = info["name"]!
        let phone = info["phone"]!
        
        if("" == name) {
            YMPageModalMessage.ShowErrorInfo("请填写姓名！", nav: self.NavController!)
            return
        }
        
        if(!YMValueValidator.IsCellPhoneNum(phone)) {
            YMPageModalMessage.ShowErrorInfo("请填写正确的手机号！", nav: self.NavController!)
            return
        }
        
        PageAppointmentViewController.PatientBasicInfo = info
        self.NavController?.popViewControllerAnimated(true)
    }
    
    public func CheckWhenInputChanged(_: YMTextField) {
        let pageController = self.Target! as! PageAppointmentPatientBasicInfoViewController
        
        let info = pageController.BodyView!.GetPatientInfo()
        
        let name = info["name"]!
        let phone = info["phone"]!
        
        if("" == name) {
            pageController.BodyView?.SetConfirmDisable()
            pageController.BodyView?.ShowErrorInfo("")
            return
        }
        
        if(!YMValueValidator.IsCellPhoneNum(phone)) {
            pageController.BodyView?.SetConfirmDisable()
            if(!pageController.BodyView!.PatientPhoneInput!.isFirstResponder() && phone != "") {
                pageController.BodyView?.ShowErrorInfo("请输入正确的手机号码！")
            }
            return
        }
        
        pageController.BodyView?.ShowErrorInfo("")
        pageController.BodyView?.SetConfirmEnable()
    }
}