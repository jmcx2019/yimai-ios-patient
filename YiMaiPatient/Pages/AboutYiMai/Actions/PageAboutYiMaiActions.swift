//
//  PageAboutYiMaiActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAboutYiMaiActions: PageJumpActions{
    override func ExtInit() {
        super.ExtInit()
    }
    
    func ShowIntro(gr: UIGestureRecognizer) {
        PageShowWebViewController.TargetUrl = "/about/introduction"
        DoJump(YMCommonStrings.CS_PAGE_SHOW_WEB_PAGE)
    }
    
    func ShowContact(gr: UIGestureRecognizer) {
        PageShowWebViewController.TargetUrl = "/about/contact-us"
        DoJump(YMCommonStrings.CS_PAGE_SHOW_WEB_PAGE)
    }
}