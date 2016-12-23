//
//  PageRegisterInputInfoActions.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterInputInfoActions: PageJumpActions {
    private var TargetView: PageRegisterInputInfoBodyView? = nil
    
    var UpdateApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        self.TargetView = self.Target as? PageRegisterInputInfoBodyView
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER_INFO_WHEN_REG,
                                 success: UpdateSuccess, error: UpdateError)
    }
    
    func UpdateSuccess(data: NSDictionary?) {
        YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA).YMGetAPPInitData()
        //        BackEndApi.DoApi()
        
        let handler = YMCoreMemDataOnceHandler(handler: LoginSuccess)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_MY_ACCOUNT_SETTING, handler: handler)
    }
    
    private func LoginSuccess(_: AnyObject?, queue: NSOperationQueue) -> Bool {
        let loginStatus = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS) as? Bool
        
        if(nil == loginStatus) {
            return false
        }
        
        let unpackedStatus = loginStatus!
        if(!unpackedStatus) {
            queue.addOperationWithBlock({ () -> Void in
                self.TargetView?.FullPageLoading.Show()
                self.UpdateUserInfo(UIButton())
            })
            return false
        } else {
            queue.addOperationWithBlock({ () -> Void in
                self.TargetView?.FullPageLoading.Hide()
                PageIndexViewController.IsFromLogin = true
                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
            })
        }
        
        return true
    }
    
    func UpdateError(data: NSError) {
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("上传信息失败，请重新上传。", nav: self.NavController!)
    }
    
    public func GenderTouched(sender: UIGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let maleAction = UIAlertAction(title: "男", style: .Default) { (act) in
            self.TargetView!.UpdateGender("男", genderNumType: "1")
        }
        let femaleAction = UIAlertAction(title: "女", style: .Default) { (act) in
            self.TargetView!.UpdateGender("女", genderNumType: "0")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(maleAction)
        alertController.addAction(femaleAction)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public func BirthdayTouched(sender: UIGestureRecognizer) {
        let datePicker = UIDatePicker( )
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        datePicker.maximumDate = NSDate()
        datePicker.minimumDate = NSDate(year: 1800, month: 1, day: 1)
        
        // 设置默认时间
        if(nil == PageRegisterInputInfoBodyView.InfoList["birthdayDate"]){
            datePicker.date = NSDate()
        } else {
            datePicker.date = PageRegisterInputInfoBodyView.InfoList["birthdayDate"] as! NSDate
        }
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "确定", style: .Default) { (act) in
            self.TargetView?.UpdateBirthday(datePicker.date)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.view.addSubview(datePicker)
        
        datePicker.anchorToEdge(Edge.Top, padding: 0, width: datePicker.width, height: datePicker.height)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func CitySelected(name: String?, id: String?) {
        if(nil == name || nil == id) {
            return
        }
        TargetView!.UpdateCity(name!, id: id!)
    }
    
    public func CityTouched(sender: UIGestureRecognizer) {
        PageSelectCityViewController.CitySelectedCallback = CitySelected
        DoJump(YMCommonStrings.CS_PAGE_SELECT_CITY_NAME)
    }
    
    func UpdateUserInfo(sender: UIButton) {
        TargetView?.FullPageLoading.Show()
        UpdateApi.YMChangeUserInfo(PageRegisterInputInfoBodyView.InfoList)
    }
}























