//
//  PageDepartmentSearchActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageDepartmentSearchActions: PageJumpActions {
    private var targetView: PageDepartmentSearchBodyView? = nil
    private var departmentApi: YMAPIUtility? = nil

    override func ExtInit() {
        targetView = self.Target! as? PageDepartmentSearchBodyView
        
        departmentApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DEPARTMENT_LIST,
                                       success: GetDepartmentList,
                                       error: GetDepartmentError)
    }
    
    private func GetDepartmentList(data: NSDictionary?) {
        let realData = data!
        
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_ALL_DEPARTMENT, data: realData["data"]!)
        targetView?.DepartmentData = realData["data"] as? [[String:AnyObject]]
        targetView?.DrawDepartments()
    }
    
    private func GetDepartmentError(error: NSError) {
        
    }

    public func DepartmentSelected(cell: YMTableViewCell) {
        PageDepartmentSearchBodyView.DepartmentSelected = cell.CellData
        self.NavController?.popViewControllerAnimated(true)
    }

    public func StartSearch(text: YMTextField) {
        
    }
    
    public func InitDepartmentList() {
        let data = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_ALL_DEPARTMENT)
        if(nil == data) {
            departmentApi?.YMGetDept()
            return
        }

        if(nil == targetView?.DepartmentData) {
            targetView?.DepartmentData = data as? [[String:AnyObject]]
        }
        
        targetView?.DrawDepartments()
    }

    public func InputManually(sender: YMButton){
        //TODO: input department manually
    }
}