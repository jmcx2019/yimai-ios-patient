//
//  PageIndexActions.swift
//  YiMaiPatient
//
//  Created by superxing on 16/9/8.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

public class PageIndexActions: PageJumpActions {
    var TargetView: PageIndexBodyView? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = self.Target as? PageIndexBodyView
    }
    
    public func SearchButtonTouched(gr: UIGestureRecognizer) {
        print("SearchButtonTouched")
    }
    
    public func AdmissionButtonTouched(gr: UIGestureRecognizer) {
//        print("AdmissionButtonTouched")
        DoJump(YMCommonStrings.CS_PAGE_GET_MY_DOCTORS_NAME)
    }
    
    public func AppointmentButtonTouched(gr: UIGestureRecognizer) {
        print("AppointmentButtonTouched")
    }
    
    public func MessageNotifyTouched(qr: UIGestureRecognizer) {
        print("MessageNotifyTouched")
    }
    
    public func MainPageMaskTouched(qr: UIGestureRecognizer) {
        let sideBarWidth = 540.LayoutVal()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        TargetView!.BodyView.frame.origin.x = 0
        TargetView!.TopView!.frame.origin.x = 0
        
        TargetView?.MainPageMask?.hidden = true
        TargetView?.SideBar.frame.origin.x = -sideBarWidth
        
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
    }
    
    public func PersonalSettingTouched(qr: UIGestureRecognizer) {
        let sideBarWidth = 540.LayoutVal()

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        TargetView!.BodyView.frame.origin.x = sideBarWidth
        TargetView!.TopView!.frame.origin.x = sideBarWidth
        
        TargetView?.MainPageMask?.hidden = false
        TargetView?.SideBar.frame.origin.x = 0
        
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
    }
    
    public func QRScanTouched(qr: UIGestureRecognizer) {
        print("QRScanTouched")
    }
    
    public func MyDocTouched(qr: UIGestureRecognizer) {
        print("MyDocTouched")
    }
    
    public func MyWalletTouched(qr: UIGestureRecognizer) {
        print("MyWalletTouched")
    }
    
    public func BroadcastTouched(qr: UIGestureRecognizer) {
        print("BroadcastTouched")
    }
    
    public func AboutTouched(qr: UIGestureRecognizer) {
        print("AboutTouched")
    }
    
    public func HealthZoneTouched(qr: UIGestureRecognizer) {
        print("HealthZoneTouched")
    }
}






































