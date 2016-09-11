//
//  YMNetworkUtility.swift
//  storyboard-try
//
//  Created by why on 16/5/5.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import AFNetworking

public typealias NetworkProgressHandler = ((NSProgress) -> Void)
public typealias NetworkSuccessHandler = ((NSURLSessionDataTask, AnyObject?) -> Void)
public typealias NetworkBodyWidthBlockBuilder = ((AFMultipartFormData) -> Void)
public typealias NetworkErrorHandler = ((NSURLSessionDataTask?, NSError) -> Void)


public class YMNetworkRequestConfig {
    public var URL: String = ""
    public var Param: AnyObject? = nil
    public var BodyWidthBlockBuilder: NetworkBodyWidthBlockBuilder? = nil
    public var ProgressHandler: NetworkProgressHandler? = nil
    public var SuccessHandler: NetworkSuccessHandler? = nil
    public var ErrorHandler: NetworkErrorHandler? = nil
}

public class YMNetwork {
    private static var UploadPhotosSessionManager: AFHTTPSessionManager? = nil
    private static var JsonRequestSessionManager: AFHTTPSessionManager? = nil
    private static var JsonSessionManager: AFHTTPSessionManager? = nil
    private static var ImageSessionManager: AFHTTPSessionManager? = nil
    
    private func BuildImageRequestManager() -> AFHTTPSessionManager {
        if(nil != YMNetwork.ImageSessionManager) {
            return YMNetwork.ImageSessionManager!
        }
        let manager = AFHTTPSessionManager()
        let reqSerializer = AFHTTPRequestSerializer()
        let resImageSerializer = AFImageResponseSerializer()
        
        resImageSerializer.acceptableContentTypes = ["image/jpeg", "image/png"]
        
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = resImageSerializer
        
        YMNetwork.ImageSessionManager! = manager
        return YMNetwork.ImageSessionManager!
    }
    
    private func BuildJsonRequestManager() -> AFHTTPSessionManager {
        if(nil != YMNetwork.JsonSessionManager) {
            return YMNetwork.JsonSessionManager!
        }
        let manager = AFHTTPSessionManager()
        let reqSerializer = AFHTTPRequestSerializer()
        let resJsonSerializer = AFJSONResponseSerializer()
        
        resJsonSerializer.acceptableContentTypes = ["application/json"]
        
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = resJsonSerializer
        
        YMNetwork.JsonSessionManager = manager
        return YMNetwork.JsonSessionManager!
    }
    
    private func BuildJsonParamRequestManager() -> AFHTTPSessionManager {
        if(nil != YMNetwork.JsonRequestSessionManager) {
            return YMNetwork.JsonRequestSessionManager!
        }
        let manager = AFHTTPSessionManager()
        let reqSerializer = AFJSONRequestSerializer()
        let resJsonSerializer = AFJSONResponseSerializer()
        
        resJsonSerializer.acceptableContentTypes = ["application/json"]
        
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = resJsonSerializer
        
        YMNetwork.JsonRequestSessionManager = manager
        return YMNetwork.JsonRequestSessionManager!
    }
    
    private func BuildImageUploadRequestManager() -> AFHTTPSessionManager {
        if(nil != YMNetwork.UploadPhotosSessionManager) {
            return YMNetwork.UploadPhotosSessionManager!
        }
        let manager = AFHTTPSessionManager()
        let reqSerializer = AFHTTPRequestSerializer()
        let resJsonSerializer = AFJSONResponseSerializer()
        
        resJsonSerializer.acceptableContentTypes = ["application/json"]
        
        manager.requestSerializer = reqSerializer
        manager.responseSerializer = resJsonSerializer
        
        YMNetwork.UploadPhotosSessionManager = manager
        return YMNetwork.UploadPhotosSessionManager!
    }
    
    public func RequestImageByGet(requestConfig: YMNetworkRequestConfig) -> NSURLSessionDataTask? {
        let imageManager = self.BuildImageRequestManager()
        
        return imageManager.GET (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }
    
    public func RequestJsonByGet(requestConfig: YMNetworkRequestConfig) -> NSURLSessionDataTask? {
        let jsonManager = self.BuildJsonRequestManager()
        
        return jsonManager.GET (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }
    
    public func RequestJsonByPost(requestConfig: YMNetworkRequestConfig) -> NSURLSessionDataTask? {
        let jsonManager = self.BuildJsonRequestManager()
        
        return jsonManager.POST (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }
    
    public func RequestJsonByPostJsonParam(requestConfig: YMNetworkRequestConfig)  -> NSURLSessionDataTask? {
        let jsonManager = self.BuildJsonParamRequestManager()
        
        return jsonManager.POST (
            requestConfig.URL,
            parameters: requestConfig.Param,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
    }
    
    public func UploadPhotosWithParam(requestConfig: YMNetworkRequestConfig) {
        let uploadManager = self.BuildImageUploadRequestManager()
        
        //        multipart/form-data; boundary=--------------------------820109731617543034119330
        //        uploadManager.requestSerializer.setValue("content_type", forHTTPHeaderField: "multipart/form-data; boundary=--------------------------820109731617543034119330")
        
        uploadManager.POST(
            requestConfig.URL,
            parameters: requestConfig.Param,
            constructingBodyWithBlock: requestConfig.BodyWidthBlockBuilder,
            progress: requestConfig.ProgressHandler,
            success: requestConfig.SuccessHandler,
            failure: requestConfig.ErrorHandler
        )
        
    }
    
    public func UploadJsonByGet() {}
    public func UploadJsonByPost() {}
    
    public func UploadFile() {}
    
    public func UploadFileWithJsonParam() {}
}




































