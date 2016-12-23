//
//  PageForgetPasswordBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageForgetPasswordBodyView: PageBodyView {
    private var ForgetActions: PageForgetPasswordActions? = nil
    private var UsernameInput: YMTextField? = nil
    private var PasswordInput: YMTextField? = nil
    public var VerifyInput: YMTextField? = nil
    public var GetVerifyCodeButton: YMButton? = nil
    
    public var Loading: YMPageLoadingView? = nil
    public var SubmitButton: YMButton? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ForgetActions = PageForgetPasswordActions(navController: self.NavController!, target: self)
        DrawUserNameInput()
        DrawNewPasswordInput()
        DrawVerifyCodeInput()
        DrawSubmitButton()
        
        Loading = YMPageLoadingView(parentView: BodyView)
    }
    
    private func DrawSubmitButton() {
        SubmitButton = YMButton()
        BodyView.addSubview(SubmitButton!)
        
        SubmitButton?.UserStringData = YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME
        SubmitButton?.addTarget(self.ForgetActions!, action: "GetPasswordBackSubmit:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        SubmitButton?.setTitle(YMRegisterStrings.CS_NEXT_STEP_BUTTON, forState: UIControlState.Normal)
        SubmitButton?.titleLabel?.font = UIFont.systemFontOfSize(36.LayoutVal())
        SubmitButton?.setBackgroundImage(UIImage(named: "CommonXLBtnBkgGray"), forState: UIControlState.Disabled)
        SubmitButton?.setBackgroundImage(UIImage(named: "CommonXLBtnBkgGreen"), forState: UIControlState.Normal)
        
        SubmitButton?.enabled = false
        
        SubmitButton?.align(Align.UnderCentered, relativeTo: VerifyInput!, padding: 40.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
    }
    
    private func DrawUserNameInput() {
        let param = TextFieldCreateParam()
        param.FontSize = 28.LayoutVal()
        param.Placholder = "请输入手机号"
        param.FontColor = YMColors.FontGray
        UsernameInput = YMLayout.GetCellPhoneField(param)
        
        BodyView.addSubview(UsernameInput!)
        UsernameInput?.anchorToEdge(Edge.Top, padding: 70.LayoutVal(),
                                    width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        UsernameInput?.SetLeftPaddingWidth(40.LayoutVal())
        UsernameInput?.SetRightPaddingWidth(40.LayoutVal())
        UsernameInput?.EditChangedCallback = ForgetActions?.CheckOnInputChanged
    }
    
    private func DrawNewPasswordInput() {
        let param = TextFieldCreateParam()
        param.FontSize = 28.LayoutVal()
        param.Placholder = "请输入新密码"
        param.FontColor = YMColors.FontGray
        PasswordInput = YMLayout.GetPasswordField(param)
        
        BodyView.addSubview(PasswordInput!)
        PasswordInput?.align(Align.UnderMatchingLeft, relativeTo: UsernameInput!,
                             padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        PasswordInput?.SetLeftPaddingWidth(40.LayoutVal())
        PasswordInput?.SetRightPaddingWidth(40.LayoutVal())
        PasswordInput?.EditChangedCallback = ForgetActions?.CheckOnInputChanged

    }
    
    private func DrawVerifyCodeInput() {
        let param = TextFieldCreateParam()
        param.FontSize = 28.LayoutVal()
        param.Placholder = "请输入验证码"
        param.FontColor = YMColors.FontGray
        VerifyInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 4)
        
        BodyView.addSubview(VerifyInput!)
        VerifyInput?.align(Align.UnderMatchingLeft, relativeTo: PasswordInput!,
                             padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        VerifyInput?.SetLeftPaddingWidth(40.LayoutVal())
        VerifyInput?.SetRightPaddingWidth(40.LayoutVal())
        VerifyInput?.EditChangedCallback = ForgetActions?.CheckOnInputChanged
        
        let verifyButtonFrame = CGRect(x: 550.LayoutVal(), y: 247.LayoutVal(), width: 160.LayoutVal(), height: 50.LayoutVal())
        GetVerifyCodeButton = YMButton(frame: verifyButtonFrame)

        GetVerifyCodeButton?.addTarget(ForgetActions!, action: "GetVerifyCode:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        BodyView.addSubview(GetVerifyCodeButton!)
        
        GetVerifyCodeButton?.setTitle(YMRegisterStrings.CS_VERIFY_CODE_BUTTON, forState: UIControlState.Normal)
        GetVerifyCodeButton?.titleLabel?.font = UIFont.systemFontOfSize(24.LayoutVal())
        GetVerifyCodeButton?.setBackgroundImage(UIImage(named: "RegisterButtonGetVerifyCodeBackground"), forState: UIControlState.Normal)
        GetVerifyCodeButton?.setBackgroundImage(UIImage(named: "RegisterButtonWaitForVerifyCodeBackground"), forState: UIControlState.Disabled)
    }
    
    public func DisableGetVerifyCodeButton() {
        self.GetVerifyCodeButton?.setTitle("重新获取(60)", forState: UIControlState.Disabled)
        self.GetVerifyCodeButton?.titleLabel?.font = YMFonts.YMDefaultFont(20.LayoutVal())
        self.GetVerifyCodeButton?.enabled = false
    }
    
    public func EnableGetVerifyCodeButton() {
        self.GetVerifyCodeButton?.titleLabel?.font = YMFonts.YMDefaultFont(24.LayoutVal())
        self.GetVerifyCodeButton?.enabled = true
    }
    
    public func VerifyPhoneBeforeGetCode() -> [String: String]? {
        let phone = self.UsernameInput?.text
        if(!YMValueValidator.IsCellPhoneNum(phone!)) {
            YMPageModalMessage.ShowErrorInfo("手机号码错误，请输入手机号码！", nav: self.NavController!)
            return nil
        }
        
        return [YMCommonStrings.CS_API_PARAM_KEY_PHONE: phone!]
    }

    public func VerifyUserInput(showInfo: Bool = false) -> [String:String]? {
        let phone = self.UsernameInput?.text
        let password = self.PasswordInput?.text
        let verifyCode = self.VerifyInput?.text
        
        if(!YMValueValidator.IsCellPhoneNum(phone!)) {
            if(showInfo) {
                YMPageModalMessage.ShowErrorInfo("手机号码错误，请重新输入！", nav: self.NavController!)
            }
            return nil
        }
        
        if(6 > password?.characters.count) {
            if(showInfo) {
                YMPageModalMessage.ShowErrorInfo("密码长度不足六位！", nav: self.NavController!)
            }
            return nil
        }
        
        let curVerifyCode = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_FORGET_VERIFY_CODE)
        if(nil == curVerifyCode) {
            if(showInfo) {
                YMPageModalMessage.ShowErrorInfo("请先获取验证码！", nav: self.NavController!)
            }
            return nil
        }
        
        let verifyCodeInString = "\(curVerifyCode!)"
        if(verifyCodeInString != verifyCode) {
            if(showInfo) {
                YMPageModalMessage.ShowErrorInfo("验证码错误！", nav: self.NavController!)
            }
            return nil
        }
        
        PageRegisterViewController.RegPhone = phone!
        PageRegisterViewController.RegPassword = password!
        
        return [
            "phone": phone!,
            "password": password!,
            "verify_code": verifyCode!
        ]
    }
    
    public func Clear() {
        UsernameInput?.text = ""
        PasswordInput?.text = ""
        VerifyInput?.text = ""

        ForgetActions?.VerifyCodeEnableCounter = 0
        SubmitButton?.enabled = false
        
        Loading?.Hide()
    }
}














