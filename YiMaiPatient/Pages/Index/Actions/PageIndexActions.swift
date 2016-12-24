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
    var AddDocApi: YMAPIUtility!
    var BannerApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        AddDocApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_ADD_TO_MY_DOCOTOR, success: AddSuccess, error: AddError)
        BannerApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_INDEX_BANNER, success: GetIndexBannerSuccess, error: GetIndexBannerError)
        TargetView = self.Target as? PageIndexBodyView
    }
    
    func GetIndexBannerSuccess(data: NSDictionary?) {
        let realData = data?["data"] as? [[String:String]]
        TargetView?.RefreshScrollImage(realData)
    }
    
    func GetIndexBannerError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func AddSuccess(data: NSDictionary?) {
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowNormalInfo("成功添加医生", nav: NavController!)
    }
    
    func AddError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowNormalInfo("成功添加医生", nav: NavController!)
    }
    
    public func SearchButtonTouched(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_GET_DEFAULT_SEARCH)
    }
    
    public func AdmissionButtonTouched(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_GET_MY_DOCTORS_NAME)
    }
    
    public func AppointmentButtonTouched(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_RECORD)
    }
    
    public func MessageNotifyTouched(qr: UIGestureRecognizer) {
        print("MessageNotifyTouched")
//        DoJump(YMCommonStrings.CS_PAGE_SELECT_FOCUSED_DEPT)
    }
    
    public func UserHeadTouched(gr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_PERSONAL_INFO_NAME)
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
        DoJump(YMCommonStrings.CS_PAGE_GET_MY_DOCTORS_NAME)
    }
    
    public func MyWalletTouched(qr: UIGestureRecognizer) {
//        print("MyWalletTouched")
        DoJump(YMCommonStrings.CS_PAGE_WALLET_RECORD)
    }
    
    public func BroadcastTouched(qr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_SYS_BROADCAST)
    }
    
    public func AboutTouched(qr: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_ABOUT_YIMAI)
    }
    
    public func HealthZoneTouched(qr: UIGestureRecognizer) {
        print("HealthZoneTouched")
    }
    
    func ScanSuccess(result: String?) {
        let ret = YMVar.TryToGetDictFromJsonStringData(result)
        if(nil == ret) {
            YMPageModalMessage.ShowNormalInfo("不能识别的医生信息，请扫描医脉平台生成的二维码。", nav: self.NavController!)
            return
        }
        let yimaiData = ret!["YMQRData"]
        if(nil == yimaiData) {
            YMPageModalMessage.ShowNormalInfo("不能识别的医生信息，请扫描医脉平台生成的二维码。", nav: self.NavController!)
            return
        }
        let docData = yimaiData! as! [String: AnyObject]
        let id = YMVar.GetStringByKey(docData, key: "id")
        if("" == id) {
            YMPageModalMessage.ShowNormalInfo("不能识别的医生信息，请扫描医脉平台生成的二维码。", nav: self.NavController!)
            return
        }
        
        TargetView?.FullPageLoading.Show()
        AddDocApi.YMAddDocotor(id)
    }
    
    func ScanFailed(result: String?) {
        YMPageModalMessage.ShowNormalInfo("不能识别的医生信息，请扫描医脉平台生成的二维码。", nav: self.NavController!)
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
        style.colorAngle = YMColors.PatientFontGreen // [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0]
        
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
        vc.scanSuccessHandler = ScanSuccess
        vc.scanFailedHandler = ScanFailed
        
        self.NavController?.pushViewController(vc, animated: true)
    }
    
    func IndexScrollImageTouched(sender: UIGestureRecognizer) {
        let img = sender.view! as! YMTouchableImageView
        
        PageShowWebViewController.TargetUrl = img.UserStringData
        DoJump(YMCommonStrings.CS_PAGE_SHOW_WEB_PAGE)
    }
}






































