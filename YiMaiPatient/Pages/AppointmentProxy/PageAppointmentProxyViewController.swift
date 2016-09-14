//
//  PageAppointmentProxyViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentProxyViewController: PageViewController {
    private var Actions: PageAppointmentProxyActions? = nil
    public var BodyView: PageAppointmentProxyBodyView? = nil
    public var Loading: YMPageLoadingView? = nil
    
    public static var SelectedDoctor:[String: AnyObject]? = nil
    public static var PatientBasicInfo: [String: String]? = nil
    public static var PatientCondition: String = ""
    public static var SelectedTime: String = ""
    public static var SelectedTimeForUpload: [String]? = nil
    
    public static var NewAppointment = true

    override func PageLayout() {
        super.PageLayout()
        Actions = PageAppointmentProxyActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentProxyBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!)
        
        Loading = YMPageLoadingView(parentView: self.view)
    }

    override func PagePreRefresh() {
        Actions?.PhotoIndex = 0
        if(PageAppointmentProxyViewController.NewAppointment) {
            PageAppointmentProxyViewController.PatientBasicInfo = nil
            PageAppointmentProxyViewController.PatientCondition = ""
            
            BodyView?.BodyView.removeFromSuperview()
            TopView?.TopViewPanel.removeFromSuperview()
            
            BodyView = PageAppointmentProxyBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约医生", navController: self.NavController!)
            PageAppointmentProxyViewController.NewAppointment = false
            BodyView?.Reload()
        } else {
            BodyView?.Reload()
            if(nil != VerifyInput(false)) {
                BodyView?.SetConfirmEnable()
            } else {
                BodyView?.SetConfirmDisable()
            }
        }
    }
    
    override func PageDisapeared() {
        if(PageAppointmentProxyViewController.NewAppointment) {
            PageAppointmentProxyViewController.PatientBasicInfo = nil
            PageAppointmentProxyViewController.PatientCondition = ""
            PageAppointmentProxyViewController.SelectedTime = ""
            
            BodyView?.BodyView.removeFromSuperview()
            TopView?.TopViewPanel.removeFromSuperview()
            
            BodyView = PageAppointmentProxyBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约医生", navController: self.NavController!)
            BodyView?.Reload()
            PageAppointmentProxyViewController.NewAppointment = false
        }
    }

    public func VerifyInput(showAlarm: Bool = true) -> [String:String]? {
        if(nil == PageAppointmentProxyViewController.PatientBasicInfo) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请填写病人基本信息！", nav: self.NavController!)
            }
            return nil
        }
        
        if(nil == PageAppointmentProxyViewController.SelectedDoctor) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请选择医生！", nav: self.NavController!)
            }
            return nil
        }
        
        if(nil == PageAppointmentProxyViewController.SelectedTimeForUpload) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请选择就诊时间！", nav: self.NavController!)
            }
            return nil
        }
        
        let basicInfo = PageAppointmentProxyViewController.PatientBasicInfo!
        var date = ""
        var amOrPm = ""
        if(0 == PageAppointmentProxyViewController.SelectedTimeForUpload?.count) {
            date = "0"
        } else {
            date = PageAppointmentProxyViewController.SelectedTimeForUpload![0]
            amOrPm = PageAppointmentProxyViewController.SelectedTimeForUpload![1]
        }
        
        let doctor = PageAppointmentProxyViewController.SelectedDoctor!
        
        let ret =
            [
                "name": "\(basicInfo["name"]!)",
                "phone": "\(basicInfo["phone"]!)",
                "sex": "\(basicInfo["gender"]!)",
                "age": "\(basicInfo["age"]!)",
                "history": "\(PageAppointmentProxyViewController.PatientCondition)",
                "doctor": "\(doctor[YMYiMaiStrings.CS_DATA_KEY_USER_ID]!)",
                "date": date,
                "am_or_pm": amOrPm
        ]
        
        return ret
    }
}































