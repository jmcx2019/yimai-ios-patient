//
//  YMPush.swift
//  YiMai
//
//  Created by why on 2016/12/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation

class YMNotificationType: NSObject {
    static let NewAppointment = "appointment"
    static let NewBroadCast = "radio"

//    static let NewAddmission = "NewAddmission"
//    static let NewFriendApply = "NewFriend"
//    static let YiMaiR1Changed = "YiMaiR1Changed"
}

typealias YMNotificationHandlerFunc = ((UINavigationController, AnyObject) -> Void)
class YMNotificationHandler: NSObject {
    static var HandlerMap: [String: YMNotificationHandlerFunc] = [
        YMNotificationType.NewAppointment: YMNotificationHandler.NewAppointment,
        YMNotificationType.NewBroadCast: YMNotificationHandler.NewBroadcast
        
//        YMNotificationType.NewAddmission: YMNotificationHandler.NewAddmission,
//        YMNotificationType.NewFriendApply: YMNotificationHandler.NewFriendApply,
//        YMNotificationType.YiMaiR1Changed: YMNotificationHandler.YiMaiR1Changed
    ]
    
    static func NewBroadcast(nav: UINavigationController, data: AnyObject) {
        PageJumpActions(navController: nav).DoJump(YMCommonStrings.CS_PAGE_SYS_BROADCAST)
    }
    
    static func NewAppointment(nav: UINavigationController, data: AnyObject) {
        let realData = data as! [NSObject: AnyObject]
        let id = realData["data-id"] as? String
        if(nil != id) {
            PageAppointmentDetailViewController.AppointmentID = id!
            PageJumpActions(navController: nav).DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
        } else {
            PageJumpActions(navController: nav).DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_RECORD)
        }
    }
    
//    static func NewAddmission(nav: UINavigationController) {
//        PageJumpActions(navController: nav).DoJump(YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME)
//    }
//    
//    static func NewFriendApply(nav: UINavigationController) {
//        PageJumpActions(navController: nav).DoJump(YMCommonStrings.CS_PAGE_NEW_FRIEND_NAME)
//    }
//    
//    static func YiMaiR1Changed(nav: UINavigationController) {
//        PageJumpActions(navController: nav).DoJump(YMCommonStrings.CS_PAGE_YIMAI_NAME)
//    }
}

class YMNotification: NSObject {
    static func DoLocalNotification(content: String, userData: AnyObject?) {
//        let localNotification: UILocalNotification = UILocalNotification()
//        
//        // 2.设置本地通知的内容
//        // 2.1.设置通知发出的时间
//        localNotification.fireDate = NSDate() //NSDate(timeInterval: NSDate().timeIntervalSinceNow) //[NSDate dateWithTimeIntervalSinceNow:3.0];
//        // 2.2.设置通知的内容
//        localNotification.alertBody = content
//        // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
//        localNotification.alertAction = "解锁"
//        // 2.4.决定alertAction是否生效
//        localNotification.hasAction = false
//        // 2.5.设置点击通知的启动图片
//        localNotification.alertLaunchImage = ""
//        // 2.6.设置alertTitle
//        localNotification.alertTitle = "医者脉连";
//        // 2.7.设置有通知时的音效
////        localNotification.soundName = @"buyao.wav";
//        // 2.8.设置应用程序图标右上角的数字
//        localNotification.applicationIconBadgeNumber = 1;
//        
//        // 2.9.设置额外信息
//        if(nil != userData) {
//            localNotification.userInfo = ["data": userData!]
//        } else {
//            localNotification.userInfo = ["data": ""]
//        }
//        
//        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
    }
}










