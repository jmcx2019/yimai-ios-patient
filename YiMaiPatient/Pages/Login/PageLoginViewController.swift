//
//  PageLoginViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

class PageLoginViewController: PageViewController {

    private var BodyView : PageLoginBodyView? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func PageLayout(){
        super.PageLayout()
        
        BodyView = PageLoginBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMLoginStrings.CS_LOGIN_PAGE_TITLE)
    }
    
    override func PageDisapeared() {
        BodyView?.ClearLoginControls()
    }
}
