//
//  YMPhotoSelector.swift
//  YiMai
//
//  Created by superxing on 16/9/5.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import QBImagePickerController
import Photos

public typealias YMPhotoSelected = (([PHAsset]) -> Void)
public typealias YMPhotoCancelSelect = ((Void) -> Void)

private class YMImagePickerController: QBImagePickerController {
}

public class YMPhotoSelector: NSObject, QBImagePickerControllerDelegate  {
    private var NavController: UINavigationController? = nil
    
    public var SelectedCallback: YMPhotoSelected? = nil
    public var CancelledCallback: YMPhotoCancelSelect? = nil
    
    private var MaxSelection: UInt = 1
    
    init(nav: UINavigationController, maxSelection: UInt = 1) {
        self.NavController = nav
        
        self.MaxSelection = maxSelection
    }
    
    public func Show() {
        let picker = QBImagePickerController()
        
        picker.mediaType = .Image
        picker.delegate = self
        picker.allowsMultipleSelection = true
        picker.maximumNumberOfSelection = self.MaxSelection
        picker.showsNumberOfSelectedAssets = true
        
        self.NavController!.presentViewController(picker, animated: true, completion: nil)
    }
    
    public func SetMaxSelection(maxSelection: UInt) {
        self.MaxSelection = maxSelection
    }
    
    public func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        if(nil != self.SelectedCallback) {
            self.SelectedCallback!(assets as! [PHAsset])
        }
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        if(nil != self.CancelledCallback) {
            self.CancelledCallback!()
        }
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
}