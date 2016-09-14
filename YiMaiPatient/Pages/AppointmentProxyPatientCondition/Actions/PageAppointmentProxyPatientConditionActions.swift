//
//  PageAppointmentProxyPatientConditionActions.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppointmentProxyPatientConditionActions: PageJumpActions {
    public func SaveCondition(sender: UIGestureRecognizer) {
        let pageController = self.Target! as! PageAppointmentProxyPatientConditionViewController
        PageAppointmentProxyViewController.PatientCondition = pageController.BodyView!.GetCondition()
        
        self.NavController?.popViewControllerAnimated(true)
    }
}