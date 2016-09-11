//
//  PageGetMyDoctorsActions.swift
//  YiMaiPatient
//
//  Created by superxing on 16/9/9.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

public class PageGetMyDoctorsActions: PageJumpActions {
    var MyDoctorApi: YMAPIUtility? = nil
    var TargetView: PageGetMyDoctorsBodyView? = nil
    
    override public func ExtInit () {
        super.ExtInit()
        TargetView = self.Target as? PageGetMyDoctorsBodyView
        MyDoctorApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_MY_DOCTOR,
                                   success: GetMyDoctorSuccess,
                                   error: GetMyDoctorError)
    }
    
    public func GetMyDoctorSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        TargetView?.LoadData(realData)
    }
    
    public func GetMyDoctorError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络通讯故障，请稍后再试", nav: self.NavController!)
        TargetView?.LoadingView?.Hide()
    }

    public func SearchInputEnded (sender: YMTextField) {
        //TODO: 跳转到搜索页面
    }
    
    public func GetMyDoctorList () {
        MyDoctorApi?.YMGetMyDoctors()
    }
    
    public func DoctorTouched(gr: UIGestureRecognizer) {
        let doctorCell = gr.view as! YMTouchableView
        let doctorData = doctorCell.UserObjectData as! [String: AnyObject]
        
        TargetView?.LoadDoctorToBox(doctorData)
    }

    public func HideBox(gr: UIGestureRecognizer) {
        TargetView?.HideBox()
    }
    
    public func AppointmentTouched(sender: UIButton) {
        //调到约诊页面
    }
    
    public func ProxyTouched(sender: UIButton) {
        //调到代约页面
    }
}












