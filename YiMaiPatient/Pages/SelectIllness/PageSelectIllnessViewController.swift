//
//  PageSelectIllnessViewController.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/24.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

class PageSelectIllnessViewController: PageViewController {
    var BodyView: PageSelectIllnessBodyView!
    static var WichPageJumpTo = ""
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSelectIllnessBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "选择标签", navController: NavController!)
        BodyView.DrawSaveButton(TopView!.TopViewPanel)
    }
    
    override func PagePreRefresh() {
        let groupedTagInfo = YMLocalData.GetData("GroupedTagInfo") as? [[String:AnyObject]]
        if(nil == groupedTagInfo) {
            YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试", nav: NavController!,callback: { (_) in
                self.NavController?.popViewControllerAnimated(true)
            })
            
            return
        }
        
        BodyView.DrawIllnessList(groupedTagInfo!)
    }
}






