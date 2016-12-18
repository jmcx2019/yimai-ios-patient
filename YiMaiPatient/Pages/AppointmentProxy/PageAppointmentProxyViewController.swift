//
//  PageAppointmentProxyViewController.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit
import Neon
import ChameleonFramework

public class PageAppointmentProxyViewController: PageViewController {
    private var Actions: PageAppointmentProxyActions? = nil
    public var BodyView: PageAppointmentProxyBodyView? = nil
    public var Loading: YMPageLoadingView? = nil
    
    public static var SelectedDoctor:[String: AnyObject]? = nil
    public static var PatientBasicInfo: [String: String]? = nil
    public static var PatientCondition: String = ""
    public static var SelectedTime: String = ""
    public static var SelectedTimeForUpload = [String]()
    
    public static var NewAppointment = true
    
    private let DatePickerPanel = UIView()
    private var DatePickerBackground: YMTouchableView!
    private let PickerPanel = UIView()
    public let DatePicker = UIDatePicker()
    private let DateToolBar = UIView(frame: CGRect(x: 0,y: 0,
        width: YMSizes.PageWidth, height: 60.LayoutVal()))

    override func PageLayout() {
        super.PageLayout()
        Actions = PageAppointmentProxyActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentProxyBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "预约", navController: self.NavController!)
        Loading = YMPageLoadingView(parentView: self.view)
        DrawDatePicker()
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
            PageHospitalSearchBodyView.HospitalSelected = nil
            PageDepartmentSearchBodyView.DepartmentSelected = nil
            BodyView?.Reload()
            DrawDatePicker()
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
            DrawDatePicker()
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
        
        let hos = BodyView!.RequireHospital!.text
        let dept = BodyView!.RequireDepartment!.text
        let jobtitle = BodyView!.RequireJobTitle!.text
        let docName = BodyView!.RequireDocName!.text
        
        if(YMValueValidator.IsEmptyString(hos)) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请指定医院！", nav: self.NavController!)
            }
            return nil
        }
        
        if(YMValueValidator.IsEmptyString(dept)) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请指定科室！", nav: self.NavController!)
            }
            return nil
        }
        
        if(YMValueValidator.IsEmptyString(jobtitle)) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请指定职称！", nav: self.NavController!)
            }
            return nil
        }
        
//        if(nil == PageAppointmentProxyViewController.SelectedTimeForUpload) {
//            if(showAlarm) {
//                YMPageModalMessage.ShowErrorInfo("请选择就诊时间！", nav: self.NavController!)
//            }
//            return nil
//        }
        
        let basicInfo = PageAppointmentProxyViewController.PatientBasicInfo!
        var date = ""
        var amOrPm = ""
        if(0 == PageAppointmentProxyViewController.SelectedTimeForUpload.count) {
            date = "0"
        } else {
            date = PageAppointmentProxyViewController.SelectedTimeForUpload[0]
            amOrPm = PageAppointmentProxyViewController.SelectedTimeForUpload[1]
        }
        
        let doctor = PageAppointmentProxyViewController.SelectedDoctor!
        
        let ret =
            [
                "name": "\(basicInfo["name"]!)",
                "phone": "\(basicInfo["phone"]!)",
                "sex": "\(basicInfo["gender"]!)",
                "age": "\(basicInfo["age"]!)",
                "demand_doctor_name": docName!,
                "demand_hospital": hos!,
                "demand_dept": dept!,
                "demand_title": jobtitle!,
                "history": "\(PageAppointmentProxyViewController.PatientCondition)",
                "locums_doctor": "\(doctor[YMYiMaiStrings.CS_DATA_KEY_USER_ID]!)",
                "date": date,
                "am_or_pm": amOrPm
        ]
        
        return ret
    }
    
    func DrawDatePicker() {
        YMLayout.ClearView(view: DatePickerPanel)
        YMLayout.ClearView(view: DateToolBar)

        self.view.addSubview(DatePickerPanel)
        DatePickerPanel.fillSuperview()
        
        DatePickerBackground = YMLayout.GetTouchableView(useObject: Actions!,
                                            useMethod: "DatePickerBackgroundTouched:".Sel())
        DatePickerBackground.backgroundColor = HexColor("#000000")
        DatePickerBackground.layer.opacity = 0
        
        DatePickerPanel.addSubview(DatePickerBackground)
        DatePickerPanel.addSubview(PickerPanel)
        
        DatePickerBackground.fillSuperview()
        
        PickerPanel.anchorToEdge(Edge.Bottom, padding: -460.LayoutVal(), width: YMSizes.PageWidth,
                                 height: 460.LayoutVal())
        PickerPanel.backgroundColor = YMColors.White
        
        PickerPanel.addSubview(DatePicker)
        PickerPanel.addSubview(DateToolBar)
        DatePicker.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 400.LayoutVal())
        
        DatePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        DatePicker.minuteInterval = 30
        DatePicker.datePickerMode = UIDatePickerMode.DateAndTime
        DatePicker.minimumDate = NSDate()
        DatePicker.date = NSDate()
        
        DatePickerPanel.hidden = true
        
        DateToolBar.backgroundColor = YMColors.DividerLineGray
        let downButton = UIButton()
        DateToolBar.addSubview(downButton)
        downButton.setTitle("完成", forState: UIControlState.Normal)
        downButton.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
        downButton.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        downButton.anchorToEdge(Edge.Right, padding: 0, width: 80.LayoutVal(), height: 60.LayoutVal())
        downButton.addTarget(Actions!, action: "DatePickedTouched:".Sel(),
                             forControlEvents: UIControlEvents.TouchUpInside)
        
        DateToolBar.align(Align.AboveMatchingLeft, relativeTo: DatePicker,
                          padding: 0, width: YMSizes.PageWidth, height: DateToolBar.height)
        
    }
    
    func ShowDatePicker() {
        DatePickerPanel.hidden = false
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        DatePickerBackground.layer.opacity = 0.7
        PickerPanel.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0,
                                      otherSize: PickerPanel.height)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
    }
    
    func HideDatePicker() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        DatePickerBackground.layer.opacity = 0
        PickerPanel.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: -PickerPanel.height,
                                      otherSize: PickerPanel.height)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
        UIView.setAnimationDidStopSelector("animationDidStop:".Sel())
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        DatePickerPanel.hidden = true
    }
}
















