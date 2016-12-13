//
//  PageAppointmentSelectTimeViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/6/2.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public class PageAppointmentSelectTimeViewController: PageViewController {
    private var Actions: PageAppointmentSelectTimeActions? = nil
    public var BodyView: PageAppointmentSelectTimeBodyView? = nil
    static var SelectedDoctor:[String: AnyObject]? = nil

    public override func PageLayout() {
        if(PageLayoutFlag) {
            BodyView = PageAppointmentSelectTimeBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
            TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "期望就诊时间", navController: self.NavController!)
            return
        }
        PageLayoutFlag=true
        
        super.PageLayout()
        Actions = PageAppointmentSelectTimeActions(navController: self.NavController, target: self)
        
    }
    
    override func PagePreRefresh() {
        BodyView = PageAppointmentSelectTimeBodyView(parentView: self.SelfView!, navController: self.NavController!, pageActions: Actions!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "期望就诊时间", navController: self.NavController!)
    }
    
    override func PageDisapeared() {
        BodyView?.BodyView.removeFromSuperview()
        BodyView = nil
        TopView?.TopViewPanel.removeFromSuperview()
        TopView = nil
    }
}
