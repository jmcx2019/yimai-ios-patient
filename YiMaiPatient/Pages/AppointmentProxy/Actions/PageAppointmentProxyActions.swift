//
//  PageAppointmentActions.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Proposer
import AFNetworking

public class PageAppointmentProxyActions: PageJumpActions, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var ApiUtility: YMAPIUtility? = nil
    var UploadApi: YMAPIUtility? = nil
    var TargetController: PageAppointmentProxyViewController? = nil
    
    var AppointmentId = ""
    var ImageForUpload: UIImage? = nil
    var PhotoIndex = 0

    override func ExtInit() {
        super.ExtInit()
        ApiUtility = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_CREATE_NEW_APPOINTMENT,
                                  success: CreateAppointmentSuccess,
                                  error: CreateAppointmentError)
        
        UploadApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPLOAD_PHOTO_APPOINTMENT,
                                 success: UploadSuccess,
                                 error: UploadError)
        
        TargetController = self.Target as? PageAppointmentProxyViewController
    }
    
    private func GetImageData(img: UIImage) -> NSData {
        var imgData = UIImageJPEGRepresentation(ImageForUpload!, 1.0)
        
        if (imgData!.length > 100*1024) {
            if (imgData!.length>1024*1024) {//1M以及以上
                imgData = UIImageJPEGRepresentation(img, 0.1)
            }else if (imgData!.length > 512*1024) {//0.5M-1M
                imgData = UIImageJPEGRepresentation(img, 0.5)
            }else if (imgData!.length > 200*1024) {//0.25M-0.5M
                imgData = UIImageJPEGRepresentation(img, 0.9)
            }
        }
        
        return imgData!
    }
    
    public func UploadBlockBuilder(formData: AFMultipartFormData) {
        let filename = "\(PhotoIndex).jpg"
        let imgData = YMLayout.GetScaledImageData(ImageForUpload!)//GetImageData(ImageForUpload!)

        formData.appendPartWithFileData(imgData, name: "img", fileName: filename, mimeType: "image/jpeg")
    }
    
    public func UploadSuccess(data: NSDictionary?) {
        PhotoIndex += 1
        if(PhotoIndex < TargetController!.BodyView!.PhotoArray.count) {
            ImageForUpload = TargetController!.BodyView!.PhotoArray[PhotoIndex]
            UploadApi?.YMUploadAddmissionPhotos(["id": AppointmentId], blockBuilder: self.UploadBlockBuilder)
        } else {
            TargetController?.Loading?.Hide()
            PhotoIndex = 0
            ImageForUpload = nil
            YMPageModalMessage.ShowNormalInfo("预约成功，请耐心等待代约回复。", nav: NavController!, callback: { (_) in
                PageAppointmentProxyViewController.NewAppointment = true
                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
            })
            DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
        }
    }
    
    public func UploadError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.Loading?.Hide()
        PhotoIndex = 0
        ImageForUpload = nil
//        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
        YMPageModalMessage.ShowNormalInfo("预约成功，请耐心等待代约回复。", nav: NavController!, callback: { (_) in
            PageAppointmentProxyViewController.NewAppointment = true
            self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
        })
    }
    
    public func PhotoScrollLeft(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoScrollRight(sender: UIGestureRecognizer) {
        
    }
    
    public func PhotoSelect(sender: UIGestureRecognizer) {
        let contacts: PrivateResource = PrivateResource.Photos
        
        proposeToAccess(contacts, agreed: {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//                let imagePicker = UIImagePickerController()
//                imagePicker.sourceType = .PhotoLibrary
//                imagePicker.delegate = self
//                
//                self.NavController!.presentViewController(imagePicker, animated: true, completion: nil)
                
                self.TargetController?.BodyView!.ShowPhotoPicker()
            }
        }, rejected: {
            let alertController = UIAlertController(title: "系统提示", message: "请去隐私设置里打开照片访问权限！", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "好的", style: .Default,
                handler: {
                    action in
                        
            })
            alertController.addAction(okAction)
            self.NavController!.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    public func imagePickerController(picker: UIImagePickerController!,
                                      didFinishPickingImage image: UIImage!,
                                                            editingInfo: [NSObject : AnyObject]!) {
        
        let img = UIImageView(image: image)
        TargetController?.BodyView!.AddImage(img)

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func CreateAppointmentSuccess(data: NSDictionary?) {

        let realData = data!["data"] as! [String: AnyObject]
        
        AppointmentId = "\(realData["id"]!)"
        if(PhotoIndex < TargetController!.BodyView!.PhotoArray.count) {
            ImageForUpload = TargetController!.BodyView!.PhotoArray[PhotoIndex]
            UploadApi?.YMUploadAddmissionPhotos(["id": AppointmentId], blockBuilder: self.UploadBlockBuilder)
        } else {
            YMPageModalMessage.ShowNormalInfo("预约成功，请耐心等待代约回复。", nav: NavController!, callback: { (_) in
                PageAppointmentProxyViewController.NewAppointment = true
                self.TargetController?.BodyView?.FullPageLoading.Hide()
                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
            })
        }
    }

    public func CreateAppointmentError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetController?.Loading?.Hide()
        YMPageModalMessage.ShowErrorInfo("网络错误，请稍后再试！", nav: self.NavController!)
    }
    
    public func DoAppointment(_: YMButton) {
        let uploadData = TargetController!.VerifyInput()
        print(uploadData)
        if(nil != uploadData) {
            TargetController?.Loading?.Show()
            ApiUtility?.YMCreateInsteadAppointment(uploadData!)
        }
    }
    
    public func TimeBySysTouched(gr: UIGestureRecognizer) {
        TargetController?.BodyView?.SetSelectTimeBySys()
    }
    
    public func TimeByUserTouched(gr: UIGestureRecognizer) {
        TargetController?.BodyView?.SetSelectTimeByUser()
        NoBackByGesturePage.DynamicPageMap[YMCurrentPage.CurrentPage] = true
        TargetController?.ShowDatePicker()
    }
    
    public func RequireHospitalBeginEdit(textField: YMTextField) -> Bool {
        TargetController?.BodyView?.AllInputResignFirstResponder()
        PageCommonSearchViewController.InitPageTitle = "选择医院"
        PageCommonSearchViewController.SearchPageTypeName =
            YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
        return false
    }
    
    public func RequireDepartmentBeginEdit(textField: YMTextField) -> Bool {
        TargetController?.BodyView?.AllInputResignFirstResponder()
        PageCommonSearchViewController.InitPageTitle = "选择科室"
        PageCommonSearchViewController.SearchPageTypeName =
            YMCommonSearchPageStrings.CS_DEPARTMENT_SEARCH_PAGE_TYPE
        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
        return false
    }
    
    func JobTitleSelected(act: UIAlertAction) {
        let title = act.title!
        TargetController?.BodyView?.RequireJobTitle?.text = title
        TargetController?.VerifyInput(false)
    }
    
    public func RequireJobTitleBeginEdit(textField: YMTextField) -> Bool {
        TargetController?.BodyView?.AllInputResignFirstResponder()
        YMJobtitleSelectModal.ShowSelectModal(NavController!, callback: self.JobTitleSelected)
//        PageCommonSearchViewController.SearchPageTypeName = YMCommonSearchPageStrings.CS_HOSPITAL_SEARCH_PAGE_TYPE
//        DoJump(YMCommonStrings.CS_PAGE_COMMON_SEARCH_NAME)
        return false
    }
    
    public func DatePickerBackgroundTouched(gr: UIGestureRecognizer) {
        NoBackByGesturePage.DynamicPageMap.removeValueForKey(YMCurrentPage.CurrentPage)
        TargetController?.HideDatePicker()
        if(0 == PageAppointmentProxyViewController.SelectedTimeForUpload.count) {
            TargetController?.BodyView?.SetSelectTimeBySys()
        }
    }
    
    public func DatePickedTouched(sender: UIButton) {
        NoBackByGesturePage.DynamicPageMap.removeValueForKey(YMCurrentPage.CurrentPage)
        TargetController?.HideDatePicker()
        
        let dateFmt = NSDateFormatter()
        let AMorPMFmt = NSDateFormatter()
        let fullFmt = NSDateFormatter()
        
        fullFmt.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFmt.locale = NSLocale(localeIdentifier: "zh_CN")
        AMorPMFmt.locale = NSLocale(localeIdentifier: "zh_CN")
        
        dateFmt.dateFormat = "yyyy-MM-dd"
        AMorPMFmt.dateFormat = "a"
        fullFmt.dateFormat = "yyyy-MM-dd a"
        
        TargetController?.BodyView?
            .UpdateTimeSelectByUser(fullFmt.stringFromDate(TargetController!.DatePicker.date))

        PageAppointmentProxyViewController.SelectedTimeForUpload.removeAll()
        PageAppointmentProxyViewController.SelectedTimeForUpload
            .append(dateFmt.stringFromDate(TargetController!.DatePicker.date))
        PageAppointmentProxyViewController.SelectedTimeForUpload
            .append(AMorPMFmt.stringFromDate(TargetController!.DatePicker.date))
    }
}



















