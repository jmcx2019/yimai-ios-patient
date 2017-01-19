//
//  PageRegisterViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

public class PageRegisterViewController: PageViewController {
    private var BodyView : PageRegisterBodyView? = nil
    
    public static var RegPhone: String = ""
    public static var RegPassword: String = ""
    public static var RegInvitedCode: String = ""
    
    override func PageLayout(){
        if(PageLayoutFlag) {return}
        PageLayoutFlag=true
        
        BodyView = PageRegisterBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMRegisterStrings.CS_REGISTER_PAGE_TITLE, navController: self.navigationController)
    }
    
    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            BodyView?.Clear()
        }
    }
}
