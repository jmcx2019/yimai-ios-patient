//
//  YMTextArea.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import KMPlaceholderTextView

public typealias YMTextTextareaEditStartCallback = ((YMTextArea) -> Bool)
public typealias YMTextTextareaEditEndCallback = ((YMTextArea) -> Void)
public typealias YMTextTextareaChangedCallback = ((YMTextArea) -> Void)

public class YMTextAreaDelegate : NSObject, UITextViewDelegate {
    public func textViewDidChange(textView: UITextView){
        if(!textView.isKindOfClass(YMTextArea)) { return }
        
        let realTextField = textView as! YMTextArea
        let curTextCount = textView.text?.characters.count
        let maxCharactersCount : Int = realTextField.MaxCharCount
        
        let selectedRange = realTextField.markedTextRange
        let lang = realTextField.textInputMode?.primaryLanguage
        let keboard = realTextField.keyboardType
        
        if("zh-Hans" == lang && UIKeyboardType.Default == keboard) {
            if(nil == selectedRange) {
                if(0 != maxCharactersCount){
                    if(curTextCount > maxCharactersCount){
                        realTextField.text = (realTextField.text! as NSString).substringToIndex(maxCharactersCount)
                    }
                }
            }
        } else {
            if(0 != maxCharactersCount){
                if(curTextCount > maxCharactersCount){
                    realTextField.text = (realTextField.text! as NSString).substringToIndex(maxCharactersCount)
                }
            }
        }
        
        if(nil != realTextField.EditChangedCallback) {
            realTextField.EditChangedCallback!(realTextField)
        }
    }
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if(!textView.isKindOfClass(YMTextArea)) { return true }
        let realTextField = textView as! YMTextArea
        if(nil != realTextField.EditStartCallback) {
            realTextField.EditStartCallback!(realTextField)
        }
        return true
    }
    
    public func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if(!textView.isKindOfClass(YMTextArea)) { return true }
        let realTextField = textView as! YMTextArea
        realTextField.resignFirstResponder()
        if(nil != realTextField.EditEndCallback) {
            realTextField.EditEndCallback!(realTextField)
        }
        return true
    }
    
    public func DownButtonTouched(sender: YMButton) {
        let textView = sender.UserObjectData as! YMTextArea
        textView.resignFirstResponder()
    }
}

public class YMTextArea: KMPlaceholderTextView {
    public var MaxCharCount: Int = 0
    public var EditStartCallback: YMTextTextareaEditStartCallback? = nil
    public var EditChangedCallback: YMTextTextareaChangedCallback? = nil
    public var EditEndCallback: YMTextTextareaEditEndCallback? = nil
    private var YMDelegate = YMTextAreaDelegate()
    
    public func SetPadding(left: CGFloat = 0.0, right: CGFloat = 0.0, top: CGFloat = 0.0, bottom: CGFloat = 0.0) {
        self.textContainerInset = UIEdgeInsetsMake(top, left, bottom, right)
    }
    
    init(aDelegate : UITextViewDelegate?) {
        super.init(frame: CGRect(), textContainer: nil)
        if(nil != aDelegate) {
            self.delegate = aDelegate
        } else {
            self.delegate = YMDelegate
        }
        
        let topView = UIToolbar(frame: CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: 60.LayoutVal()))
        topView.backgroundColor = YMColors.DividerLineGray
        let downButton = YMButton()
        topView.addSubview(downButton)
        downButton.setTitle("完成", forState: UIControlState.Normal)
        downButton.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        downButton.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        downButton.anchorToEdge(Edge.Right, padding: 0, width: 80.LayoutVal(), height: 60.LayoutVal())
        downButton.UserObjectData = self
        downButton.addTarget(YMDelegate, action: "DownButtonTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        self.inputAccessoryView = topView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}