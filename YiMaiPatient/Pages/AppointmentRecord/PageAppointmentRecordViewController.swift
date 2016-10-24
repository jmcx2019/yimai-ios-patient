//
//  PageAppointmentRecordViewController.swift
//  YiMaiPatient
//
//  Created by superxing on 16/10/21.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

class PageAppointmentRecordViewController: PageViewController {
    var BodyView: PageAppointmentRecordBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageAppointmentRecordBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "约诊记录", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.Reload()
    }

}
