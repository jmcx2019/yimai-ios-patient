//
//  PageAppointmentProxyPatientConditionBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/5/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentProxyPatientConditionBodyView: PageBodyView {
    private var ConditionInput: YMTextArea? = nil

    override func ViewLayout() {
        super.ViewLayout()
        DrawTextArea()
    }
    
    public func GetCondition() -> String {
        return ConditionInput!.text
    }
    
    private func DrawTextArea() {
        ConditionInput = YMTextArea(aDelegate: nil)
        
        BodyView.addSubview(ConditionInput!)
        
        let padding = 40.LayoutVal()
        ConditionInput?.SetPadding(padding,right: padding,top: padding,bottom: padding)
        ConditionInput?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        ConditionInput?.textColor = YMColors.FontGray
        ConditionInput?.anchorToEdge(Edge.Top, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: 320.LayoutVal())
        ConditionInput?.MaxCharCount = 500
        ConditionInput?.text = PageAppointmentProxyViewController.PatientCondition
        ConditionInput?.EditChangedCallback = ConditionChanged
    }
    
    public func ConditionChanged(_: YMTextArea) {
        PageAppointmentProxyViewController.PatientCondition = GetCondition()
    }
    
    public func DrawSpecialTopButton(topView: UIView) {
        let button = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "SaveCondition:".Sel())
        
        button.backgroundColor = YMColors.None
        
        let buttonBkg = YMLayout.GetSuitableImageView("TopViewSmallButtonBkg")
        let label = UILabel()
        label.text = "保存"
        label.textColor = YMColors.White
        label.font = YMFonts.YMDefaultFont(30.LayoutVal())
        label.sizeToFit()
        
        button.addSubview(buttonBkg)
        button.addSubview(label)
        
        topView.addSubview(button)
        button.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 24.LayoutVal(), width: buttonBkg.width, height: buttonBkg.height)
        
        buttonBkg.anchorInCenter(width: buttonBkg.width, height: buttonBkg.height)
        label.anchorInCenter(width: label.width, height: label.height)
    }
}