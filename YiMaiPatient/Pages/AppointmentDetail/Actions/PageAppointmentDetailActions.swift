//
//  PageAppointmentDetailActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import ImageViewer
import UShareUI
import UMSocialNetwork

public class PageAppointmentDetailActions: PageJumpActions, ImageProvider {
    var TargetView: PageAppointmentDetailBodyView? = nil
    private var DetailApi: YMAPIUtility? = nil
    private var PayApi: YMAPIUtility? = nil
    private var ConfirmApi: YMAPIUtility!
    
    var TachedImageIdx: Int = 0
    public var imageCount: Int { get { return TargetView!.ImageList.count } }
    public func provideImage(completion: UIImage? -> Void) {
        if(0 == TargetView!.ImageList.count) {
            completion(nil)
        } else {
            completion(TargetView!.ImageList[0].image)
        }
    }
    public func provideImage(atIndex index: Int, completion: UIImage? -> Void) {
        completion(TargetView!.ImageList[index].image)
    }

    override func ExtInit() {
        super.ExtInit()
        
        DetailApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_APPOINTMENT_DETAIL,
                                 success: DetailGetSuccess, error: DetailGetError)
        
        PayApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GOTO_PAY, success: GoToPaySuccess, error: GoToPayError)
        ConfirmApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CONFIRM_RESCHEDULED, success: ConfirmRescheduledSuccess, error: ConfirmRescheduledError)
        TargetView = self.Target as? PageAppointmentDetailBodyView
    }
    
    func ConfirmRescheduledSuccess(data: NSDictionary?) {
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowNormalInfo("改期已确认，请等待医生回复", nav: NavController!) { (_) in
            self.NavController!.popViewControllerAnimated(true)
        }
    }
    
    func ConfirmRescheduledError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络繁忙，请稍后再试", nav: NavController!)
    }
    
    private func DetailGetSuccess(data: NSDictionary?) {
        print(data)
        TargetView?.LoadData(data!)
    }
    
    private func DetailGetError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    func GoToPaySuccess(data: NSDictionary?) {
        let prepayInfo = data!["data"] as! [String: AnyObject]
        let req = PayReq()
        req.openID = "\(prepayInfo["appid"]!)"
        req.partnerId = "\(prepayInfo["partnerid"]!)"
        req.prepayId = "\(prepayInfo["prepayid"]!)"
        req.nonceStr = "\(prepayInfo["noncestr"]!)"
        req.timeStamp = UInt32(NSDate().timeIntervalSince1970)
        req.package = "\(prepayInfo["package"]!)"
        req.sign = "\(prepayInfo["sign"]!)"
        TargetView?.FullPageLoading.Hide()
        WXApi.sendReq(req)
    }
    
    func GoToPayError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        TargetView?.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("订单生成失败！", nav: self.NavController!)
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
    
    public func ImageTouched(gr: UITapGestureRecognizer) {
        let img = gr.view as! YMTouchableImageView
        let imgIdx = Int(img.UserStringData)
        let galleryViewController = GalleryViewController(imageProvider: self, displacedView: self.TargetView!.ParentView!,
                                                          imageCount: TargetView!.ImageList.count, startIndex: imgIdx!, configuration: YMLayout.DefaultGalleryConfiguration())
        NavController!.presentImageGallery(galleryViewController)
    }
    
    func GoToPayTouched(sender: YMButton) {
        print(PageAppointmentDetailViewController.AppointmentID)
        PayApi?.YMGetPayInfo(PageAppointmentDetailViewController.AppointmentID)
        TargetView?.FullPageLoading.Show()
    }
    
    func ConfirmTouched(sender: YMButton) {
        TargetView?.FullPageLoading.Show()
        ConfirmApi.YMConfirmRescheduled(PageAppointmentDetailViewController.AppointmentID)
    }
    
    func ShareTouched(_: YMButton) {
        var plateforms = [AnyObject]()
        
        if(UMSocialManager.defaultManager().isInstall(UMSocialPlatformType.WechatSession)) {
            plateforms.append(UMSocialPlatformType.WechatSession.rawValue)
            plateforms.append(UMSocialPlatformType.WechatTimeLine.rawValue)
        }
        if(UMSocialManager.defaultManager().isInstall(UMSocialPlatformType.Sina)) {
            plateforms.append(UMSocialPlatformType.Sina.rawValue)
        }
        UMSocialUIManager.setPreDefinePlatforms(plateforms)
        UMSocialUIManager.showShareMenuViewInWindowWithPlatformSelectionBlock { (type, data) in
            //            print(type)
            let msg = UMSocialMessageObject()
            let shareObj = UMShareWebpageObject()
            shareObj.title = "医者脉连-看专家"
            shareObj.descr = "医者仁心，脉脉相连。 医脉帮助医生拓展人脉，与北上广一线专家相连，同时集医疗、科研、社区三大功能于一体，构架和谐医患关系。"
//            shareObj.thumbImage = self.TargetView.UserHead.image //YMVar.GetStringByKey(YMVar.MyUserInfo, key: "head_url")
            shareObj.webpageUrl = "http://www.medi-link.cn"
            msg.shareObject = shareObj
            UMSocialManager.defaultManager().shareToPlatform(type, messageObject: msg, currentViewController: self.NavController!, completion: { (data, error) in
                print(error)
            })
        }
    }
}











