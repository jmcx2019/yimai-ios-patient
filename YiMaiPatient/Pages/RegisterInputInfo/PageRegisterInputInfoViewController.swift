//
//  PageRegisterInputInfoViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

public class PageRegisterInputInfoViewController: PageViewController {
    public var BodyView: PageRegisterInputInfoBodyView? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageRegisterInputInfoBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "完善信息")
    }
}
