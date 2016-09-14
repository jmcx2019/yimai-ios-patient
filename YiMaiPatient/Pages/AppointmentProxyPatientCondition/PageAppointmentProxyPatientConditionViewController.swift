//
//  PageAppointmentProxyPatientConditionViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentProxyPatientConditionViewController: PageViewController {
    private var Actions: PageAppointmentProxyPatientConditionActions? = nil
    public var BodyView: PageAppointmentProxyPatientConditionBodyView? = nil
    
    public override func PageLayout() {
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()
        Actions = PageAppointmentProxyPatientConditionActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentProxyPatientConditionBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "现病史", navController: self.NavController!)
        
        BodyView!.DrawSpecialTopButton(TopView!.TopViewPanel)
    }
}
