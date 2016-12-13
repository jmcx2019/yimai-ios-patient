//
//  PagePersonalInfoActions.swift
//  YiMaiPatient
//
//  Created by superxing on 16/10/24.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import AFNetworking
import Neon
import Photos
import Toucan

class PagePersonalInfoActions: PageJumpActions {
    var TargetView: PagePersonalInfoBodyView!
    var UpdateApi: YMAPIUtility!
    
    var UploadApi: YMAPIUtility!
    var ImageForUpload: UIImage? = nil

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PagePersonalInfoBodyView
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_MY_INFO, success: UpdateSuccess, error: UpdateError)
        
        UploadApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPLOAD_USER_HEAD,
                                 success: UploadSuccess,
                                 error: UploadError)
        
        print(TargetView)
    }
    
    func UploadSuccess(data: NSDictionary?) {
        print("upload success")
        let realData = data!["data"] as! [String: AnyObject]
        YMVar.MyInfo = realData
        TargetView.UpdateUserHead()
        TargetView.FullPageLoading.Hide()
    }
    
    func UploadError(err: NSError) {
        YMAPIUtility.PrintErrorInfo(err)
        TargetView.FullPageLoading.Hide()
    }
    
    func UpdateSuccess(data: NSDictionary?) {
        print(data)
    }
    
    func UpdateError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
    }

    func BirthdayTouched(gr: UIGestureRecognizer) {
        let datePicker = UIDatePicker( )
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        datePicker.maximumDate = NSDate()
        datePicker.minimumDate = NSDate(year: 1800, month: 1, day: 1)
        
        // 设置默认时间
        if(nil == PageRegisterInputInfoBodyView.InfoList["birthday"]){
            datePicker.date = NSDate()
        } else {
            datePicker.date = PageRegisterInputInfoBodyView.InfoList["birthday"] as! NSDate
        }
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "确定", style: .Default) { (act) in
            let birthdayStr = self.TargetView?.UpdateBirthday(datePicker.date)
            
            self.UpdateApi.YMChangeUserInfo(["birthday": birthdayStr!])
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.view.addSubview(datePicker)
        
        datePicker.anchorToEdge(Edge.Top, padding: 0, width: datePicker.width, height: datePicker.height)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func GenderTouched(sender: UIGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let maleAction = UIAlertAction(title: "男", style: .Default) { (act) in
            self.TargetView!.UpdateGender("男", genderNumType: "1")
            self.UpdateApi.YMChangeUserInfo(["sex": "1"])
        }
        let femaleAction = UIAlertAction(title: "女", style: .Default) { (act) in
            self.TargetView!.UpdateGender("女", genderNumType: "0")
            self.UpdateApi.YMChangeUserInfo(["sex": "0"])
        }
        alertController.addAction(cancelAction)
        alertController.addAction(maleAction)
        alertController.addAction(femaleAction)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func UploadBlockBuilder(formData: AFMultipartFormData) {
        let filename = "head_img.jpg"
        let imgData = YMLayout.GetScaledImageData(ImageForUpload!)
        
        formData.appendPartWithFileData(imgData, name: "head_img", fileName: filename, mimeType: "image/jpeg")
    }
    
    func HeadImagesSelected(selectedPhotos: [PHAsset]) {
        ImageForUpload = YMLayout.TransPHAssetToUIImage(selectedPhotos[0])
//        TargetView.UpdateUserHead()
        TargetView.FullPageLoading.Show()
        UploadApi.YMUploadUserHead(["head_img": "head_img.jpg"], blockBuilder: UploadBlockBuilder)
    }
    
    func HeadImgTouched(gr: UIGestureRecognizer) {
        //TODO: big picture
    }
    
    func ChangeHeadImage(_: UIGestureRecognizer) {
        TargetView.PhotoPikcer?.Show()
    }
    
    func LogoutTouched(_: UIGestureRecognizer) {
        YMCoreDataEngine.Clear()
        YMLocalData.ClearLogin()
        YMVar.Clear()
//        YMBackgroundRefresh.Stop()
        //        YMAPICommonVariable.ClearCallbackMap()
        self.DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
    }
}





