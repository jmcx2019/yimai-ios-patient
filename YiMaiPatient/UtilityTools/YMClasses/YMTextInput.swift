//
//  YMTextInput.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public typealias YMTextFieldEditStartCallback = ((YMTextField) -> Bool)
public typealias YMTextFieldEditEndCallback = ((YMTextField) -> Void)
public typealias YMTextFieldChangedCallback = ((YMTextField) -> Void)

public class YMTextFieldDelegate : NSObject, UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(!textField.isKindOfClass(YMTextField)) { return true }
        
        let realTextField = textField as! YMTextField
        
        textField.resignFirstResponder()
        if(nil != realTextField.EditEndCallback) {
            realTextField.EditEndCallback!(realTextField)
        }
        
        return true;
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        if(!textField.isKindOfClass(YMTextField)) { return }
        
        let realTextField = textField as! YMTextField
        
        textField.resignFirstResponder()
        if(nil != realTextField.EditEndCallback) {
            realTextField.EditEndCallback!(realTextField)
        }
        
        return;
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(!textField.isKindOfClass(YMTextField)) { return true }
        
        let realTextField = textField as! YMTextField
	
        if(nil != realTextField.EditStartCallback) {
            return realTextField.EditStartCallback!(realTextField)
        }
        
        return realTextField.Editable
    }
    
    public func DidChange(textField: UITextField) {
        if(!textField.isKindOfClass(YMTextField)) { return }
        
        let realTextField = textField as! YMTextField
        let curTextCount = textField.text?.characters.count
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
    
    public func DownButtonTouched(sender: YMButton) {
        let textField = sender.UserObjectData as! YMTextField
        textField.resignFirstResponder()
        if(nil != textField.EditEndCallback) {
            textField.EditEndCallback!(textField)
        }
    }
}

public class YMTextField: UITextField {
    public var MaxCharCount: Int = 0
    public var Editable: Bool = true
    public var EditStartCallback: YMTextFieldEditStartCallback? = nil
    public var EditEndCallback: YMTextFieldEditEndCallback? = nil
    public var EditChangedCallback: YMTextFieldChangedCallback? = nil
    private var YMDelegate = YMTextFieldDelegate()
    
    public func SetLeftPaddingWidth(leftPadding: CGFloat, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        let leftPaddingFrame = CGRect(x: 0,y: 0,width: leftPadding,height: self.height)
        self.leftView = UIView(frame: leftPaddingFrame)
    }
    
    public func SetRightPaddingWidth(rightPadding: CGFloat, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.rightViewMode = paddingMode
        let rightPaddingFrame = CGRect(x: 0,y: 0,width: rightPadding,height: self.height)
        self.rightView = UIView(frame: rightPaddingFrame)
    }
    
    public func SetBothPaddingWidth(padding: CGFloat, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.SetLeftPaddingWidth(padding, paddingMode: paddingMode)
        self.SetRightPaddingWidth(padding, paddingMode: paddingMode)
    }
    
    public func SetLeftPadding(leftPaddingWidth: CGFloat, leftPaddingImage: String, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        let paddingFrame = CGRect(x: 0,y: 0,width: leftPaddingWidth, height: self.height)
        let paddingView = UIView(frame: paddingFrame)
        let paddingIcon = YMLayout.GetSuitableImageView(leftPaddingImage)
        
        paddingView.addSubview(paddingIcon)
        paddingIcon.anchorInCenter(width: paddingIcon.width, height: paddingIcon.height)
        
        self.leftView = paddingView
    }
    
    public func SetRightPadding(rightPaddingWidth: CGFloat, rightPaddingImage: String, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.rightViewMode = paddingMode
        let paddingFrame = CGRect(x: 0,y: 0,width: rightPaddingWidth, height: self.height)
        let paddingView = UIView(frame: paddingFrame)
        let paddingIcon = YMLayout.GetSuitableImageView(rightPaddingImage)
        
        paddingView.addSubview(paddingIcon)
        paddingIcon.anchorInCenter(width: paddingIcon.width, height: paddingIcon.height)
        
        self.rightView = paddingView
    }
    
    public func SetLeftPadding(leftPadding: UIView, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        self.leftView = leftPadding
    }
    
    public func SetRightPadding(rightPadding: UIView, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.rightViewMode = paddingMode
        self.rightView = rightPadding
    }
    
    public func SetBothPadding(leftPadding: UIView, rightPadding: UIView, paddingMode: UITextFieldViewMode = UITextFieldViewMode.Always) {
        self.leftViewMode = paddingMode
        self.rightViewMode = paddingMode
        
        self.leftView = leftPadding
        self.rightView = rightPadding
    }
    
    init(aDelegate : UITextFieldDelegate?) {
        super.init(frame: CGRect())
        if(nil != aDelegate) {
            self.delegate = aDelegate
        } else {
            self.delegate = YMDelegate
        }
        
        self.addTarget(self.YMDelegate, action: "DidChange:".Sel(), forControlEvents: UIControlEvents.EditingChanged)
        
        let topView = UIToolbar(frame: CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: 60.LayoutVal()))
        topView.backgroundColor = YMColors.DividerLineGray
        let downButton = YMButton()
        topView.addSubview(downButton)
        downButton.setTitle("完成", forState: UIControlState.Normal)
        downButton.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
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


















