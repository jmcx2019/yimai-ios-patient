//
//  PageGetMyDoctorsActions.swift
//  YiMaiPatient
//
//  Created by superxing on 16/9/9.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

public class PageGetMyDoctorsActions: PageJumpActions {
    var MyDoctorApi: YMAPIUtility? = nil
    
    override public func ExtInit () {
        super.ExtInit()
        
        MyDoctorApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_MY_DOCTOR, success: <#T##YMAPIJsonCallback##YMAPIJsonCallback##(NSDictionary?) -> Void#>, error: <#T##YMAPIErrorCallback##YMAPIErrorCallback##(NSError) -> Void#>)
    }
    
    public func GetMyDoctorSuccess(data: NSDictionary?) {
        print(data)
    }
    
    public func GetMyDoctorError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }

    public func SearchInputEnded (sender: YMTextField) {
        
    }
    
    public func GetMyDoctorList () {
        MyDoctorApi?.YMGetMyDoctors()
    }
}












