//
//  PageAppointmentRecordActions.swift
//  YiMaiPatient
//
//  Created by superxing on 16/10/21.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

class PageAppointmentRecordActions: PageJumpActions {
    var TargetView: PageAppointmentRecordBodyView!
    var AppointmentApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        AppointmentApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_LIST,
                                      success: GetAppointmentListSuccess, error: GetAppointmentListError)
        
        TargetView = Target as! PageAppointmentRecordBodyView
    }
    
    func GetAppointmentListSuccess(data: NSDictionary?) {
        if(nil == data) {
            TargetView.FullPageLoading.Hide()
            TargetView.ShowWaitForConfirm()
            return
        }
        
        TargetView.AppointmentList = data!["data"] as? [String: [[String: AnyObject]]]
        print(TargetView.AppointmentList)

        TargetView.ShowWaitForConfirm()
        TargetView.FullPageLoading.Hide()
    }
    
    func GetAppointmentListError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func WaitForConfirmTabTouched(gr: UIGestureRecognizer) {
        print("WaitForConfirmTabTouched")
        TargetView.ShowWaitForConfirm()
    }
    
    func WaitForDiagnosisTabTouched(gr: UIGestureRecognizer) {
        print("WaitForDiagnosisTabTouched")
        TargetView.ShowWaitForDiagnosis()
    }
    
    func AlreadyCompletedTabTouched(gr: UIGestureRecognizer) {
        print("AlreadyCompletedTabTouched")
        TargetView.ShowAlreadyCompleted()
    }
    
    func CellTouched(gr: UIGestureRecognizer) {
        print("CellTouched")
        let cell = gr.view as! YMTouchableView
        let cellData = cell.UserObjectData as! [String: AnyObject]
        PageAppointmentDetailViewController.AppointmentID = "\(cellData["id"]!)"
//        PageAppointmentDetailViewController.RecordInfo = cellData
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
    }
}






