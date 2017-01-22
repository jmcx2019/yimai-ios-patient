//
//  YMBackgroundRefresh.swift
//  YiMaiPatient
//
//  Created by why on 2017/1/20.
//  Copyright © 2017年 yimai. All rights reserved.
//

import Foundation
import UIKit

typealias YMBackgroundRefreshCallback = (AnyObject?, Bool) -> Void

enum YMBackgroundCallbackFor {
    case SystemMessage
    
    static let AllType = [SystemMessage]
}

class YMBkgRefreshRunner: NSObject {
    var GetNewMsg: YMAPIUtility!
    var CallbackList = [YMBackgroundCallbackFor: [YMBackgroundRefreshCallback]]()
    
    override init() {
        super.init()
        
        for type in YMBackgroundCallbackFor.AllType {
            CallbackList[type] = [YMBackgroundRefreshCallback]()
        }
        
        let keyPrefix = "BackgroundRefreshApi"
        GetNewMsg = YMAPIUtility(key: keyPrefix + "GetNewMsg", success: GetNewMsgSuccess, error: GetNewMsgError)
    }
    
    func CallSystemMessageHandler(data: AnyObject?, isSuccess: Bool) {
        let callbacks = CallbackList[YMBackgroundCallbackFor.SystemMessage]
        for cb in callbacks! {
            cb(data, isSuccess)
        }
    }
    
    func GetNewMsgSuccess(data: NSDictionary?) {
        CallSystemMessageHandler(data, isSuccess: true)
    }
    
    func GetNewMsgError(error: NSError) {
        CallSystemMessageHandler(error, isSuccess: false)
    }
    
    func DoRefresh() {
        GetNewMsg.YMGetNewMessage()
    }
    
    func RegisterCallback(type: YMBackgroundCallbackFor, cb: YMBackgroundRefreshCallback) {
        CallbackList[type]?.append(cb)
    }
    
    deinit {
        CallbackList.removeAll()
    }
}

class YMBackgroundRefresh: NSObject {
    private static var RefreshTimer: NSTimer? = nil
    private static var Runner: YMBkgRefreshRunner!
    private static var Running = false

    static func Start() {
        if(YMBackgroundRefresh.Running) {
            return
        }
        YMBackgroundRefresh.Running = true
        Runner = YMBkgRefreshRunner()
        YMBackgroundRefresh.RefreshTimer = NSTimer.scheduledTimerWithTimeInterval(2.0,
                                                                                  target: YMBackgroundRefresh.Runner,
                                                                                  selector: "DoRefresh".Sel(),
                                                                                  userInfo: nil, repeats: true)
        let runloop = NSRunLoop.currentRunLoop()
        runloop.addTimer(YMBackgroundRefresh.RefreshTimer!, forMode: NSRunLoopCommonModes)
    }
    
    static func Stop() {
        YMBackgroundRefresh.Running = false
        YMBackgroundRefresh.RefreshTimer?.invalidate()
        YMBackgroundRefresh.RefreshTimer = nil
        Runner = nil
    }
    
    static func Now() {
        YMBackgroundRefresh.RefreshTimer?.fire()
    }
    
    static func RegisterCallback(type: YMBackgroundCallbackFor, cb: YMBackgroundRefreshCallback) {
        if(!YMBackgroundRefresh.Running) {
            return
        }
        
        YMBackgroundRefresh.Runner.RegisterCallback(type, cb: cb)
    }
}




























