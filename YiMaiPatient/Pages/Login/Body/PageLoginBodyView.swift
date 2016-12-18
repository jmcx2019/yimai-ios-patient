//
//  PageLoginBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageLoginBodyView : NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    
    private let BodyPanel : UIScrollView = UIScrollView()
    
    private var UsernameInput : YMTextField? = nil
    private var PasswordInput : YMTextField? = nil
    
    private var LoginButton :YMButton = YMButton()
    private var ForgotButton : YMButton = YMButton()
    private var RegisterButton : YMButton = YMButton()
    
    private var ErrorInfoLabel: UILabel = UILabel()
    
    private let BodyTopPadding = 70.LayoutVal()
    private let InputHeight = 80.LayoutVal()
    private let InputFontSize = 28.LayoutVal()
    private let InputPaddingLeft = 38.LayoutVal()
    
    private let ButtonLayerPaddingTop = 70.LayoutVal()
    private let ButtonLayerHeight = 145.LayoutVal()
    
    private let LoginButtonWidth = 670.LayoutVal()
    private let LoginButtonHeight = 90.LayoutVal()
    private let TextButtonPadding = 30.LayoutVal()
    
    private var Actions : PageLoginActions? = nil
    
    private var LoginLoadingView: YMPageLoadingView? = nil
    
    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageLoginActions(navController: navController, target: self)
        
        self.ViewLayout()
        
        self.LoginLoadingView = YMPageLoadingView(parentView: ParentView!)
    }
    
    private func ViewLayout(){
        ParentView?.addSubview(BodyPanel)
        BodyPanel.fillSuperview()
        BodyPanel.contentInset = UIEdgeInsets(top: YMSizes.PageTopHeight, left: 0, bottom: 0, right: 0)
        BodyPanel.backgroundColor = YMColors.BackgroundGray
        
        DrawInputLayer()
        DrawButtonLayer()
    }
    
    private func DrawInputLayer() {
        func GetInput(placeholder : String) -> YMTextField{
            let newInput = YMTextField(aDelegate: nil)
            
            newInput.placeholder = placeholder
            newInput.backgroundColor = YMColors.White
            newInput.font = UIFont.systemFontOfSize(InputFontSize)
            
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: InputPaddingLeft, height: InputHeight))
            newInput.leftViewMode = UITextFieldViewMode.Always
            newInput.leftView = leftView
            newInput.returnKeyType = UIReturnKeyType.Done
            
            BodyPanel.addSubview(newInput)
            return newInput
        }
        
        UsernameInput = GetInput(YMLoginStrings.CS_USERNAME_PLACEHOLDER)
        PasswordInput = GetInput(YMLoginStrings.CS_PASSWORD_PLACEHOLDER)
        
        PasswordInput?.secureTextEntry = true
        
        UsernameInput?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: BodyTopPadding, otherSize: InputHeight)
        PasswordInput?.align(Align.UnderMatchingLeft, relativeTo: UsernameInput!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: InputHeight)
        
        UsernameInput?.keyboardType = UIKeyboardType.NumberPad
        
        BodyPanel.addSubview(ErrorInfoLabel)
        ErrorInfoLabel.textColor = YMColors.AlarmFontColor
        ErrorInfoLabel.font = YMFonts.YMDefaultFont(20.LayoutVal())
        ErrorInfoLabel.align(Align.UnderMatchingLeft, relativeTo: PasswordInput!, padding: 12.LayoutVal(), width: YMSizes.PageWidth, height: 20.LayoutVal())
        ErrorInfoLabel.frame.origin.x = InputPaddingLeft
        
        UsernameInput?.EditChangedCallback = self.InputVerify
        PasswordInput?.EditChangedCallback = self.InputVerify
    }
    
    private func InputVerify(_: YMTextField) {
        let userName = UsernameInput?.text
        let pwd = PasswordInput?.text
        
        if(!YMValueValidator.IsEmptyString(userName!) && !YMValueValidator.IsEmptyString(pwd!)) {
            LoginButton.enabled = true
        } else {
            LoginButton.enabled = false
        }
    }
    
    private func GetLoginButton(text: String, invalidImage: String, activtiyImage: String) -> YMButton {
        let newButton = YMButton()
        
        newButton.setTitle(text, forState: UIControlState.Normal)
        newButton.setBackgroundImage(UIImage(named: invalidImage), forState: UIControlState.Disabled)
        newButton.setBackgroundImage(UIImage(named: activtiyImage), forState: UIControlState.Normal)
        newButton.titleLabel?.font = UIFont.systemFontOfSize(34.LayoutVal())
        newButton.enabled = false
        
        return newButton
    }
    
    private func GetTextButton(text: String, align: UIControlContentHorizontalAlignment) -> YMButton {
        let newButton = YMButton(frame: CGRect(x: 0,y: 0,width: 140.LayoutVal(),height: 22.LayoutVal()))
        newButton.setTitle(text, forState: UIControlState.Normal)
        newButton.titleLabel?.font = UIFont.systemFontOfSize(22.LayoutVal())
        newButton.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        newButton.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Highlighted)
        newButton.contentHorizontalAlignment = align
        
        return newButton
    }
    
    private func BindButtonActions() {
        LoginButton.UserStringData = YMCommonStrings.CS_PAGE_INDEX_NAME
        RegisterButton.UserStringData = YMCommonStrings.CS_PAGE_REGISTER_NAME
//        ForgotButton.UserStringData = YMCommonStrings.CS_PAGE_FORGET_PASSWORD_NAME
        
        LoginButton.addTarget(self.Actions, action: "DoLogin:".Sel(),
                              forControlEvents: UIControlEvents.TouchUpInside)
        RegisterButton.addTarget(self.Actions, action: "PageJumpTo:".Sel(),
                                 forControlEvents: UIControlEvents.TouchUpInside)
        ForgotButton.addTarget(self.Actions, action: "PageJumpTo:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func DrawButtonLayer(){
        LoginButton = GetLoginButton(YMLoginStrings.CS_LOGIN_LABEL_TITLE,
                                     invalidImage: "CommonXLBtnBkgGray",
                                     activtiyImage: "CommonXLBtnBkgGreen")
        ForgotButton = GetTextButton(YMLoginStrings.CS_FORGOT_LABEL_TITLE, align: UIControlContentHorizontalAlignment.Left)
        RegisterButton = GetTextButton(YMLoginStrings.CS_REGISTER_LABEL_TITLE, align: UIControlContentHorizontalAlignment.Right)
        
        let loginButtonLayer = UIView()
        loginButtonLayer.addSubview(LoginButton)
        loginButtonLayer.addSubview(ForgotButton)
        loginButtonLayer.addSubview(RegisterButton)
        
        BodyPanel.addSubview(loginButtonLayer)
        loginButtonLayer.align(Align.UnderMatchingLeft, relativeTo: PasswordInput!, padding: ButtonLayerPaddingTop, width: YMSizes.PageWidth, height: ButtonLayerHeight)
        
        LoginButton.anchorToEdge(Edge.Top, padding: 0, width: LoginButtonWidth, height: LoginButtonHeight)
        ForgotButton.align(Align.UnderMatchingLeft, relativeTo: LoginButton, padding: TextButtonPadding, width: ForgotButton.width, height: ForgotButton.height)
        RegisterButton.align(Align.UnderMatchingRight, relativeTo: LoginButton, padding: TextButtonPadding, width: RegisterButton.width, height: RegisterButton.height)
        
        BindButtonActions()
    }
    
    private func CheckInputAndShowErrors() -> Bool {
        let username = self.UsernameInput?.text
        let password = self.PasswordInput?.text
        
        if("" == username || nil == username) {
            self.ShowErrorInfo("请输入手机号！")
            return false
        }
        
        if("" == password || nil == password) {
            self.ShowErrorInfo("请输入密码！")
            return false
        }
        
        if(!YMValueValidator.IsCellPhoneNum(username!)) {
            self.ShowErrorInfo("非法的手机号码！")
            return false
        }
        
        return true
    }
    
    public func DisableLoginControls() {
        self.LoginLoadingView?.Show()
        self.UsernameInput?.enabled = false
        self.PasswordInput?.enabled = false
        ErrorInfoLabel.text = ""
    }
    
    public func EnableLoginControls() {
        self.LoginLoadingView?.Hide()
        self.UsernameInput?.enabled = true
        self.PasswordInput?.enabled = true
    }
    
    public func ClearLoginControls() {
        self.LoginLoadingView?.Hide()
        
        self.UsernameInput?.text = ""
        self.PasswordInput?.text = ""
        
        self.UsernameInput?.enabled = true
        self.PasswordInput?.enabled = true
    }
    
    public func ShowErrorInfo(info: String) {
        ErrorInfoLabel.text = info
    }
    
    public func GetUserInputInfo() -> [String: String]? {
        if(!self.CheckInputAndShowErrors()) {
            return nil
        }
        
        let username = self.UsernameInput?.text
        let password = self.PasswordInput?.text
        
        return ["phone":username!, "password": password!]
    }
}