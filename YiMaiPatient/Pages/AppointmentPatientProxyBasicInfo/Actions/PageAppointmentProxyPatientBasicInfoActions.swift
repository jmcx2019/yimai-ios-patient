//
//  PageAppointmentProxyPatientBasicInfoActions.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentProxyPatientBasicInfoActions: PageJumpActions {
    public func BasicInfoDone(sender: UIGestureRecognizer) {
        let pageController = self.Target! as! PageAppointmentProxyPatientBasicInfoViewController
        
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
        
        PageAppointmentProxyViewController.PatientBasicInfo = info
        self.NavController?.popViewControllerAnimated(true)
    }
    
    public func CheckWhenInputChanged(_: YMTextField) {
        let pageController = self.Target! as! PageAppointmentProxyPatientBasicInfoViewController
        
        let info = pageController.BodyView!.GetPatientInfo()
        
        let name = info["name"]!
        let phone = info["phone"]!
        
        if("" == name) {
            pageController.BodyView?.SetConfirmDisable()
            return
        }
        
        if(!YMValueValidator.IsCellPhoneNum(phone)) {
            pageController.BodyView?.SetConfirmDisable()
            return
        }
        
        pageController.BodyView?.SetConfirmEnable()
    }
}