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
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageAppointmentDetailBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "约诊详细信息", navController: self.NavController!)
    }

    override func PagePreRefresh() {
        BodyView?.GetDetail()
    }
    
    override func PageDisapeared() {
        BodyView!.Clear()
    }
}
