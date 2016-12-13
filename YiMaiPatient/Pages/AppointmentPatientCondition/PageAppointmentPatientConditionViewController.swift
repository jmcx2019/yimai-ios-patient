//
//  PageAppointmentPatientConditionViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentPatientConditionViewController: PageViewController {
    private var Actions: PageAppointmentPatientConditionActions? = nil
    public var BodyView: PageAppointmentPatientConditionBodyView? = nil
    
    public override func PageLayout() {
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        super.PageLayout()
        Actions = PageAppointmentPatientConditionActions(navController: self.NavController, target: self)
        BodyView = PageAppointmentPatientConditionBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "现病史", navController: self.NavController!)
        
        BodyView!.DrawSpecialTopButton(TopView!.TopViewPanel)
    }
    
    override func PagePreRefresh() {
        BodyView?.ConditionInput?.text = PageAppointmentViewController.PatientCondition
    }
}
