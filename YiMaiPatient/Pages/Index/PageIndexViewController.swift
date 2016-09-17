//
//  PageIndexViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit
import Neon

public class PageIndexViewController: PageViewController {
    public var BodyView: PageIndexBodyView? = nil
    override func PageLayout() {
        super.PageLayout()
        BodyView = PageIndexBodyView(parentView: self.SelfView!, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.SelfView!, titleString: "")

        BodyView?.DrawTopBtn(TopView!.TopViewPanel)
        BodyView?.DrawSideBar()
    }
    
    override func PagePreRefresh() {
        super.PagePreRefresh()
        YMCurrentPage.CurrentPage = YMCommonStrings.CS_PAGE_INDEX_NAME
    }
}
