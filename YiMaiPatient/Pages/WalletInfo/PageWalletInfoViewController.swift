//
//  PageWalletInfoViewController.swift
//  YiMaiPatient
//
//  Created by old-king on 16/11/15.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

class PageWalletInfoViewController: PageViewController {
    var BodyView: PageWalletInfoBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageWalletInfoBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "钱包", navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.DrawFullBody()
    }
}
