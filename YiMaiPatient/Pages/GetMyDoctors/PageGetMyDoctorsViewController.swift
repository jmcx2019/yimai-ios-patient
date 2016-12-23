//
//  PageGetMyDoctorsViewController.swift
//  YiMaiPatient
//
//  Created by superxing on 16/9/9.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

class PageGetMyDoctorsViewController: PageViewController {
    var BodyView: PageGetMyDoctorsBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageGetMyDoctorsBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "选择医生", navController: self.NavController!)
    }
    
    override func PageDisapeared() {
        BodyView?.Clear()
    }
    
    override func PagePreRefresh() {
        BodyView?.FullPageLoading?.Show()
        BodyView?.DoctorsActions?.GetMyDoctorList()
    }

}
