//
//  PageSelectFocusedDeptController.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/22.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation

class PageSelectFocusedDeptViewController: PageViewController {
    var BodyView: PageSelectFocusedDeptBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageSelectFocusedDeptBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "选择标签", navController: NavController!)
        BodyView.DrawNextStepButton(TopView!.TopViewPanel)
    }
    
    override func PagePreRefresh() {
        BodyView.FullPageLoading.Show()
        let groupedTagInfo = YMLocalData.GetData("GroupedTagInfo") as? [[String:AnyObject]]
        BodyView.GetSelectedTagArr()

        self.BodyView.DrawSearchPanel()
        BodyView.SearchInput.resignFirstResponder()
        if(nil == groupedTagInfo) {
            BodyView.DeptActions.GetDeptApi.YMGetDept()
        } else {
            print("data from local data")
            YMDelay(0.1, closure: { 
                self.BodyView.LoadData(groupedTagInfo!)
                self.BodyView.FullPageLoading.Hide()
            })
        }
    }
    
    override func PageDisapeared() {
        YMLayout.ClearView(view: BodyView.BodyView)
        BodyView.SearchInput.text = ""
        BodyView.SearchInput.resignFirstResponder()
    }
}

