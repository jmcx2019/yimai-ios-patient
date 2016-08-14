//
//  PageSelectCityViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit

public class PageSelectCityViewController: PageViewController {
    public var BodyView: PageSelectCityBodyView? = nil

    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSelectCityBodyView(parentView: self.view, navController: self.navigationController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: YMLoginStrings.CS_LOGIN_PAGE_TITLE)
    }

}
