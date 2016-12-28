//
//  PageAppointmentPatientBasicInfoBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentPatientBasicInfoBodyView: PageBodyView{
    private var PatientNamePanel = UIView()
    private var PatientPhonePanel = UIView()
    private var PatientGenderPanel = UIView()
    private var PatientAgePanel = UIView()
    
    private var PatientNameInput: YMTextField? = nil
    var PatientPhoneInput: YMTextField? = nil
    private var PatientGenderInput: YMTextField? = nil
    private var PatientAgeInput: YMTextField? = nil
    
    private var ConfirmButton: YMButton? = nil

    private let ErrorMsgLabel = ActiveLabel()
    
    public func Reload(){}
    
    public func GetPatientInfo() -> [String: String] {
        var info = [String: String]()
        
        info["name"] = PatientNameInput!.text
        info["phone"] = PatientPhoneInput!.text
        info["gender"] = PatientGenderInput!.text
        info["age"] = PatientAgeInput!.text
        
        if("男" == info["gender"]){
            info["gender"] = "1"
        } else {
            info["gender"] = "0"
        }
        
        return info
    }
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray

        DrawInputGroup()
        DrawConfirmButton()
    }
    
    func ShowErrorInfo(msg: String) {
        ErrorMsgLabel.text = msg
    }
    
    public func ShowGenderSelector(textField: YMTextField) -> Bool {
        let alertController = UIAlertController(title: "选择性别", message: nil, preferredStyle: .Alert)
        let goBack = UIAlertAction(title: "男", style: .Default,
                                   handler: {
                                    action in
                                    self.PatientGenderInput?.text = "男"
        })
        
        let goOn = UIAlertAction(title: "女", style: .Default,
                                 handler: {
                                    action in
                                    self.PatientGenderInput?.text = "女"

        })
        
        goBack.setValue(YMColors.PatientFontGreen, forKey: "titleTextColor")
        goOn.setValue(YMColors.PatientFontGreen, forKey: "titleTextColor")
        
        alertController.addAction(goBack)
        alertController.addAction(goOn)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)
        return false
    }
    
    private func DrawInputGroup() {
        func BuildInputPanel(placeholder: String, inputWidth: CGFloat, panel: UIView, maxCount: Int, isPhone: Bool = false) -> YMTextField {
            let param = TextFieldCreateParam()
            
            param.Placholder = placeholder
            param.FontSize = 28.LayoutVal()
            param.FontColor = YMColors.PatientFontGreen
            var input: YMTextField
            if(isPhone) {
                input = YMLayout.GetCellPhoneField(param)
            } else {
                input = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: maxCount)
            }
            
            panel.addSubview(input)
            input.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: inputWidth, height: 80.LayoutVal())

            return input
        }
        
        BodyView.addSubview(PatientNamePanel)
        BodyView.addSubview(PatientPhonePanel)
        BodyView.addSubview(PatientGenderPanel)
        BodyView.addSubview(PatientAgePanel)
        
        BodyView.addSubview(ErrorMsgLabel)
        
        PatientNamePanel.backgroundColor = YMColors.White
        PatientPhonePanel.backgroundColor = YMColors.White
        PatientGenderPanel.backgroundColor = YMColors.White
        PatientAgePanel.backgroundColor = YMColors.White
        
        PatientNamePanel.anchorToEdge(Edge.Top, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        PatientPhonePanel.align(Align.UnderMatchingLeft, relativeTo: PatientNamePanel,
                               padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        PatientGenderPanel.align(Align.UnderMatchingLeft, relativeTo: PatientPhonePanel,
                                padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        PatientAgePanel.align(Align.UnderMatchingLeft, relativeTo: PatientGenderPanel,
                                padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        ErrorMsgLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        ErrorMsgLabel.textAlignment = NSTextAlignment.Center
        ErrorMsgLabel.textColor = YMColors.AlarmFontColor
        ErrorMsgLabel.align(Align.UnderCentered, relativeTo: PatientAgePanel, padding: 80.LayoutVal(), width: YMSizes.PageWidth, height: 24.LayoutVal())

        PatientNameInput = BuildInputPanel("患者姓名（必填）", inputWidth: 670.LayoutVal(), panel: PatientNamePanel, maxCount: 10)
        PatientPhoneInput = BuildInputPanel("电话（必填）", inputWidth: 400.LayoutVal(), panel: PatientPhonePanel, maxCount: 13, isPhone: true)
        PatientGenderInput = BuildInputPanel("性别", inputWidth: 670.LayoutVal(), panel: PatientGenderPanel, maxCount: 1)
        PatientAgeInput = BuildInputPanel("年龄", inputWidth: 670.LayoutVal(), panel: PatientAgePanel, maxCount: 3)
        PatientAgeInput?.keyboardType = UIKeyboardType.NumberPad
        
        PatientGenderInput?.EditStartCallback = self.ShowGenderSelector
        
        let basicAction = Actions as? PageAppointmentPatientBasicInfoActions
        PatientNameInput?.EditChangedCallback = basicAction?.CheckWhenInputChanged
        PatientPhoneInput?.EditChangedCallback = basicAction?.CheckWhenInputChanged
        PatientPhoneInput?.EditEndCallback = basicAction?.CheckWhenInputChanged
    }
    
    private func DrawConfirmButton() {
        ConfirmButton = YMButton()//YMLayout.GetTouchableView(useObject: Actions!, useMethod: "BasicInfoDone:".Sel())
        ParentView!.addSubview(ConfirmButton!)
        ConfirmButton?.anchorToEdge(Edge.Bottom, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 98.LayoutVal())

        ConfirmButton?.backgroundColor = YMColors.CommonBottomGray
        ConfirmButton?.addTarget(Actions!, action: "BasicInfoDone:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        ConfirmButton?.setTitle("完 成", forState: UIControlState.Normal)
        ConfirmButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        ConfirmButton?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmButton?.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        ConfirmButton?.enabled = false
    }
    
    public func SetConfirmEnable() {
        ConfirmButton?.enabled = true
        ConfirmButton?.backgroundColor = YMColors.PatientFontGreen
    }
    
    public func SetConfirmDisable() {
        ConfirmButton?.enabled = false
        ConfirmButton?.backgroundColor = YMColors.CommonBottomGray
    }
}
































