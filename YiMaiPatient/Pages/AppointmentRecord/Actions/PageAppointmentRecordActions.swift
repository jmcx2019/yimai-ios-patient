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
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageAppointmentRecordBodyView
    }
    
    func WaitForConfirmTabTouched(gr: UIGestureRecognizer) {
        print("WaitForConfirmTabTouched")
    }
    
    func WaitForDiagnosisTabTouched(gr: UIGestureRecognizer) {
        print("WaitForDiagnosisTabTouched")
    }
    
    func AlreadyCompletedTabTouched(gr: UIGestureRecognizer) {
        print("AlreadyCompletedTabTouched")
    }
    
    func CellTouched(gr: UIGestureRecognizer) {
        print("CellTouched")
    }
}






