//
//  PageCommonTextInputViewController.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import UIKit

public enum PageCommonTextInputType {
    case Text
    case Tel
}

public typealias PageCommonTextInputResult = ((text: String) -> Void)

class PageCommonTextInputViewController: PageViewController {
    var BodyView: PageCommonTextInputBodyView!
    
    static var TitleString = ""
    static var Placeholder = ""
    static var InputType = PageCommonTextInputType.Text
    static var InputMaxLen: Int = 20
    static var Result: PageCommonTextInputResult? = nil
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageCommonTextInputBodyView(parentView: self.view, navController: self.NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: PageCommonTextInputViewController.TitleString, navController: self.NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.DrawTextInput()
    }
    
    override func PageDisapeared() {
        PageCommonTextInputViewController.Result?(text: BodyView.TextInput.text!)
        
        PageCommonTextInputViewController.TitleString = ""
        PageCommonTextInputViewController.Placeholder = ""
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Text
        PageCommonTextInputViewController.InputMaxLen = 20
        PageCommonTextInputViewController.Result = nil
    }
}
