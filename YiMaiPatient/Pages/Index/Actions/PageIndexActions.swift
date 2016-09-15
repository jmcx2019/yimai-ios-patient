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
        DoJump(YMCommonStrings.CS_PAGE_GET_DEFAULT_SEARCH)
    }
    
    public func AdmissionButtonTouched(gr: UIGestureRecognizer) {
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
        TargetView?.SideBar.layer.opacity = 0.0

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
        
        TargetView?.SideBar.layer.opacity = 1.0
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        UIView.commitAnimations()
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
    
    public func QRButtonTouched(sender : UITapGestureRecognizer) {
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 44
        
        //扫码框周围4个角的类型设置为在框的上面
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On
        //扫码框周围4个角绘制线宽度
        style.photoframeLineW = 6
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24
        
        //显示矩形框
        style.isNeedShowRetangle = true;
        
        //动画类型：网格形式，模仿支付宝
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        //网格图片
        //        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"]
        
        //码框周围4个角的颜色
        style.colorAngle = YMColors.FontBlue // [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0]
        
        //矩形框颜色
        style.colorRetangleLine = YMColors.FontGray // [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
        
        //非矩形框区域颜色
        style.red_notRecoginitonArea = 247.0/255
        style.green_notRecoginitonArea = 202.0/255
        style.blue_notRecoginitonArea = 15.0/255
        style.alpa_notRecoginitonArea = 0.2
        
        let vc = LBXScanViewController()
        //        SubLBXScanViewController *vc = [SubLBXScanViewController new];
        vc.scanStyle = style
        
        //开启只识别矩形框内图像功能
        vc.isOpenInterestRect = true
        
        self.NavController?.pushViewController(vc, animated: true)
    }
}






































