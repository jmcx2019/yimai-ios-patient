//
//  PageAppointmentDetailActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentDetailActions: PageJumpActions {
    private var TargetView: PageAppointmentDetailBodyView? = nil
    private var DetailApi: YMAPIUtility? = nil

    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL,
                                 success: DetailGetSuccess, error: DetailGetError)
        TargetView = self.Target as? PageAppointmentDetailBodyView
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    public func GetDetail() {
        DetailApi?.YMGetAppointmentDetail(PageAppointmentDetailViewController.AppointmentID)
    }
    
    public func TextDetailTouched(sender: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollLeft (_: UIGestureRecognizer) {
        
    }
    
    public func ImageScrollRight (_: UIGestureRecognizer) {
        
    }
}