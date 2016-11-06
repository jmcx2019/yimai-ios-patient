//
//  PageAppointmentDetailViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentDetailViewController: PageViewController {
    public var BodyView: PageAppointmentDetailBodyView? = nil
    public static var AppointmentID: String = ""
    static var RecordInfo = [String:AnyObject]()
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageAppointmentDetailBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "约诊详细信息", navController: self.NavController!)
        print(self)
    }

    override func PagePreRefresh() {
        BodyView?.GetDetail()
    }
    
    override func PageDisapeared() {
        print("isMovingToParentViewController : \(self.isMovingToParentViewController())")
        print("isMovingFromParentViewController : \(self.isMovingFromParentViewController())")
        if(self.isMovingFromParentViewController()) {
            BodyView!.Clear()
            BodyView!.FullPageLoading.Hide()
        }
    }
    
    override func YMUpdateStateFromWXPay() {
        super.YMUpdateStateFromWXPay()
        BodyView!.FullPageLoading.Show()
        self.NavController?.popViewControllerAnimated(true)
//        BodyView!.Clear()
//        BodyView!.GetDetail()
    }
    
    override func YMShowErrorFromWXPay() {
        super.YMShowErrorFromWXPay()
        YMPageModalMessage.ShowErrorInfo("支付失败，请重试！", nav: self.NavController!)
    }
}
