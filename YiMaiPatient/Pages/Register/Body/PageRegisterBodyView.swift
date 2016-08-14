//
//  PageRegisterBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterBodyView: NSObject {
    private var ParentView : UIView? = nil
    private var NavController : UINavigationController? = nil
    private var Actions : PageRegisterActions? = nil
    
    private var CellPhoneInput : YMTextField? = nil
    private var PasswordInput : YMTextField? = nil
    public var VerifyCodeInput : YMTextField? = nil
//    private var InvitedCodeInput : YMTextField? = nil
    
    public var GetVerifyCodeButton : YMButton? = nil
    public var NextStepCodeButton : YMButton? = nil
    
    private var AgreeButton : YMButton? = nil
    private var AgreeCheckbox : UIImageView? = nil
    private var AgreementCheckedImage : UIImage = UIImage(named: "RegisterCheckboxAgreeChecked")!
    private var AgreementUncheckedImage : UIImage = UIImage(named: "RegisterCheckboxAgreeUnchecked")!
    
    private let BodyView : UIScrollView = UIScrollView()
    
    private let InputStartTop = 70.LayoutVal()
    private let InputHeight = 80.LayoutVal()
    private let InputMargin : CGFloat = 1.0
    private let InputLeftPadding : CGFloat = 40.LayoutVal()
    
    private let VerifyButtonFrame = CGRect(x: 550.LayoutVal(), y: 248.LayoutVal(), width: 160.LayoutVal(), height: 50.LayoutVal())
    private let NextStepButtonFrame = CGRect(x: 40.LayoutVal(), y: 383.LayoutVal(), width: 670.LayoutVal(), height: 90.LayoutVal())
    
    private let AgreeButtonFrame = CGRect(x: 84.LayoutVal(), y: 585.LayoutVal(), width: 330.LayoutVal(), height: 24.LayoutVal())
    
    public var AgreeChecked = true
    
    convenience init(parentView: UIView, navController: UINavigationController) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = PageRegisterActions(navController: navController, target: self)
        self.ViewLayout()
    }
    
    public func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        
        DrawInputGroup()
        DrawButtonGroup()
        DrawAgreeCheckbox()
    }
    
    public func ToggleAgreementStatus() {
        self.AgreeChecked = !self.AgreeChecked
        
        if(self.AgreeChecked){
            AgreeCheckbox?.image = AgreementCheckedImage
        } else {
            AgreeCheckbox?.image = AgreementUncheckedImage
        }
    }
    
    private func GetInputLeftPadding(width: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: width, height: InputHeight))
    }
    
    private func DrawInputGroup(){
        let inputParam = TextFieldCreateParam()
        inputParam.FontSize = 28.LayoutVal()
        
        CellPhoneInput = YMLayout.GetCellPhoneField(inputParam)
        CellPhoneInput?.placeholder = YMRegisterStrings.CS_USERNAME_PLACEHOLDER
        
        PasswordInput = YMLayout.GetPasswordField(inputParam)
        PasswordInput?.placeholder = YMRegisterStrings.CS_PASSWORD_PLACEHOLDER
        
        VerifyCodeInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 5)
        VerifyCodeInput?.placeholder = YMRegisterStrings.CS_VERIFY_CODE_PLACEHOLDER
        
//        InvitedCodeInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 20)
//        InvitedCodeInput?.placeholder = YMRegisterStrings.CS_INVITED_CODE_PLACEHOLDER
        
        BodyView.addSubview(CellPhoneInput!)
        BodyView.addSubview(PasswordInput!)
        BodyView.addSubview(VerifyCodeInput!)
//        BodyView.addSubview(InvitedCodeInput!)
        
        CellPhoneInput?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: InputStartTop, otherSize: InputHeight)
        PasswordInput?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: CellPhoneInput!, padding: InputMargin, height: InputHeight)
        VerifyCodeInput?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: PasswordInput!, padding: InputMargin, height: InputHeight)
//        InvitedCodeInput?.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: VerifyCodeInput!, padding: InputMargin, height: InputHeight)
        
        CellPhoneInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
        PasswordInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
        VerifyCodeInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
//        InvitedCodeInput?.SetLeftPadding(GetInputLeftPadding(InputLeftPadding))
        
        CellPhoneInput?.EditChangedCallback = Actions?.CheckWhenInputChanged
        PasswordInput?.EditChangedCallback = Actions?.CheckWhenInputChanged
        VerifyCodeInput?.EditChangedCallback = Actions?.CheckWhenInputChanged
    }
    
    private func DrawButtonGroup() {
        GetVerifyCodeButton = YMButton(frame: VerifyButtonFrame)
        NextStepCodeButton = YMButton(frame: NextStepButtonFrame)
        
        NextStepCodeButton?.UserStringData = YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME
        NextStepCodeButton?.addTarget(self.Actions, action: "NextStep:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        GetVerifyCodeButton?.addTarget(self.Actions, action: "GetVerifyCode:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        BodyView.addSubview(GetVerifyCodeButton!)
        BodyView.addSubview(NextStepCodeButton!)
        
        GetVerifyCodeButton?.setTitle(YMRegisterStrings.CS_VERIFY_CODE_BUTTON, forState: UIControlState.Normal)
        GetVerifyCodeButton?.titleLabel?.font = UIFont.systemFontOfSize(24.LayoutVal())
        GetVerifyCodeButton?.setBackgroundImage(UIImage(named: "RegisterButtonGetVerifyCodeBackground"), forState: UIControlState.Normal)
        GetVerifyCodeButton?.setBackgroundImage(UIImage(named: "RegisterButtonWaitForVerifyCodeBackground"), forState: UIControlState.Disabled)
        
        NextStepCodeButton?.setTitle(YMRegisterStrings.CS_NEXT_STEP_BUTTON, forState: UIControlState.Normal)
        NextStepCodeButton?.titleLabel?.font = UIFont.systemFontOfSize(36.LayoutVal())
        NextStepCodeButton?.setBackgroundImage(UIImage(named: "CommonXLBtnBkgGray"), forState: UIControlState.Disabled)
        NextStepCodeButton?.setBackgroundImage(UIImage(named: "CommonXLBtnBkgGreen"), forState: UIControlState.Normal)
        NextStepCodeButton?.enabled = false
    }
    
    private func DrawAgreeCheckbox() {
        AgreeButton = YMButton(frame: AgreeButtonFrame)
        AgreeCheckbox = YMLayout.GetTouchableImageView(useObject: self.Actions!,
                                                       useMethod: "AgreementImageTouched:".Sel(),
                                                       imageName: "RegisterCheckboxAgreeChecked")
        
        AgreeButton?.addTarget(self.Actions, action: "AgreementButtonTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        AgreeButton?.setTitle(YMRegisterStrings.CS_AGREE_LABEL_BUTTON, forState: UIControlState.Normal)
        AgreeButton?.titleLabel?.font = UIFont.systemFontOfSize(24.LayoutVal())
        AgreeButton?.setTitleColor(YMColors.FontLightGray, forState: UIControlState.Normal)
        AgreeButton?.titleLabel?.textAlignment = NSTextAlignment.Left
        
        let checkboxFrame = CGRect(x: 40.LayoutVal(), y: 585.LayoutVal(), width: (AgreeCheckbox?.width)!, height: (AgreeCheckbox?.height)!)
        AgreeCheckbox?.frame = checkboxFrame
        
        BodyView.addSubview(AgreeButton!)
        BodyView.addSubview(AgreeCheckbox!)
    }
    
    public func VerifyPhoneBeforeGetCode() -> [String: String]? {
        let phone = self.CellPhoneInput?.text
        if(!YMValueValidator.IsCellPhoneNum(phone!)) {
            YMPageModalMessage.ShowErrorInfo("手机号码错误，请输入手机号码！", nav: self.NavController!)
            return nil
        }
        
        return [YMCommonStrings.CS_API_PARAM_KEY_PHONE: phone!]
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
    
    public func VerifyInput(showAlarm: Bool = true) -> [String:String]? {
        let phone = self.CellPhoneInput?.text
        let password = self.PasswordInput?.text
        let verifyCode = self.VerifyCodeInput?.text
        
        //TODO: 医脉邀请码
        if(!self.AgreeChecked) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请先同意服务条款！", nav: self.NavController!)
            }
            return nil
        }
        
        if(!YMValueValidator.IsCellPhoneNum(phone!)) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("手机号码错误，请重新输入！", nav: self.NavController!)
            }
            return nil
        }
        
        if(6 > password?.characters.count) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("密码长度不足六位！", nav: self.NavController!)
            }
            return nil
        }
        
        let curVerifyCode = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_REG_VERIFY_CODE)
        if(nil == curVerifyCode) {
            if(showAlarm) {
                YMPageModalMessage.ShowErrorInfo("请先获取验证码！", nav: self.NavController!)
            }
            return nil
        }
        
        let verifyCodeInString = "\(curVerifyCode!)"
        if(verifyCodeInString != verifyCode) {
            if(showAlarm) {
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
    }}