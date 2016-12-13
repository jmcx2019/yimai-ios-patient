//
//  PageSearchDefaultActions.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/9/11.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

public class PageSearchDefaultActions: PageJumpActions {
    var SearchInitApi: YMAPIUtility? = nil
    var SearchApi: YMAPIUtility? = nil
    var TargetView: PageSearchDefaultBodyView? = nil

    override func ExtInit() {
        super.ExtInit()
        TargetView = self.Target as? PageSearchDefaultBodyView
        SearchInitApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DEFAULT_SEARCH,
                                   success: GetDoctorSuccess,
                                   error: GetDoctorError)
        SearchApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_DOCTOR_SEARCH,
                                     success: SearchSuccess,
                                     error: SearchError)
    }
    
    public func GetDoctorSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        TargetView?.LoadData(realData)
    }
    
    public func GetDoctorError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
//        YMPageModalMessage.ShowErrorInfo("网络通讯故障，请稍后再试", nav: self.NavController!)
        TargetView?.LoadingView?.Hide()
    }
    
    public func SearchSuccess(data: NSDictionary?) {
//        let realData = data!["data"] as! [[String: AnyObject]]
//        TargetView?.LoadData(realData)
//        print(data!["users"])
        print(data)
        TargetView?.LoadSearchResult(data!["users"] as! [String: AnyObject])
        TargetView?.LoadingView?.Hide()
    }
    
    public func SearchError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowErrorInfo("网络通讯故障，请稍后再试", nav: self.NavController!)
        TargetView?.LoadingView?.Hide()
    }
    
    func DoctorTouched(gr: UIGestureRecognizer) {
        let doctorCell = gr.view as! YMTouchableView
        let doctorData = doctorCell.UserObjectData as! [String: AnyObject]

        TargetView?.LoadDoctorToBox(doctorData)
    }
    
    func DoSearch() {
        let type = TargetView?.CurrentFilter["type"]
        if(nil != type || !YMValueValidator.IsEmptyString(TargetView?.SearchInput.text)) {
            TargetView?.LoadingView?.Show()
            var searchParam = [String: String]()
            if(nil != type) {
                searchParam[type!] = TargetView!.CurrentFilter["val"]!
            }
            searchParam["field"] = TargetView?.SearchInput.text
            
            SearchApi?.YMDoctorSearch(searchParam)
        } else {
            
            return
        }
    }
    
    func GetDefaultSearch() {
        SearchInitApi?.YMGetDefaultSearch()
    }
    
    func SearchInputEnded(sender: YMTextField) {
        //跳转到搜索页面或者刷新本页面
        DoSearch()
    }
    
    func ProvTabTouched(gr: UIGestureRecognizer) {
        //按省份搜索
    }
    
    func HosTabTouched(gr: UIGestureRecognizer) {
        //按医院搜索
    }
    
    func DeptTabTouched(gr: UIGestureRecognizer) {
        //按科室搜索
    }
    
    func JobtitleTabTouched(gr: UIGestureRecognizer) {
        //按职称搜索
    }
    
    public func HideBox(gr: UIGestureRecognizer) {
        TargetView?.HideBox()
    }
    
    public func ShowMore(sender: YMButton) {
        //TODO: 显示所有搜索结果
        let docData = sender.UserObjectData as! [[String: AnyObject]]
        TargetView?.LoadMoreSearchData(docData)
    }
    
    public func AppointmentTouched(sender: UIButton) {
        PageAppointmentViewController.SelectedDoctor = TargetView?.SelectedDoc
        PageAppointmentSelectTimeViewController.SelectedDoctor = TargetView?.SelectedDoc
        PageAppointmentViewController.ByPlatform = false
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_TIME)
    }
    
    public func ProxyTouched(sender: UIButton) {
        //调到代约页面
        PageAppointmentProxyViewController.SelectedDoctor = TargetView?.SelectedDoc
        PageAppointmentProxyViewController.NewAppointment = true
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_PROXY_NAME)
    }
    
    public func PlatformProxyBtn(sender: UIButton) {
        PageAppointmentViewController.SelectedDoctor = TargetView?.SelectedDoc
        PageAppointmentSelectTimeViewController.SelectedDoctor = TargetView?.SelectedDoc
        PageAppointmentViewController.NewAppointment = true
        PageAppointmentViewController.ByPlatform = true
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_TIME)
    }
}













