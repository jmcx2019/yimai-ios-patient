//
//  PageRegisterInputInfoBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageRegisterInputInfoBodyView : PageBodyView {
    private var InfoActions: PageRegisterInputInfoActions? = nil
    
    private var GenderCell: YMTouchableView? = nil
    private var BirthdayCell: YMTouchableView? = nil
    private var CityCell: YMTouchableView? = nil
    
    public let ConfirmButton = YMButton()
    
    public static var InfoList = [String: AnyObject]()

    override func ViewLayout() {
        super.ViewLayout()
        
        InfoActions = PageRegisterInputInfoActions(navController: self.NavController!, target: self)
        DrawCells()
        DrawHint()
        DrawConfirmButton()
    }
    
    private func DrawConfirmButton() {
        ConfirmButton.setTitle("提交", forState: UIControlState.Normal)
        ConfirmButton.backgroundColor = YMColors.PatientDisabledBtnBkgGray
        ConfirmButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmButton.setTitleColor(YMColors.PatientFontGray, forState: UIControlState.Disabled)
        
        ConfirmButton.enabled = false
        
        ConfirmButton.UserStringData = YMCommonStrings.CS_PAGE_INDEX_NAME
        ConfirmButton.addTarget(InfoActions!, action: "UpdateUserInfo:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        ParentView!.addSubview(ConfirmButton)
        ConfirmButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
    }
    
    public func SetConfirmButtonEnable() {
        ConfirmButton.enabled = true
        ConfirmButton.backgroundColor = YMColors.PatientFontGreen
    }
    
    public func SetConfirmButtonDisabled() {
        ConfirmButton.enabled = true
        ConfirmButton.backgroundColor = YMColors.PatientFontGray
    }
    
    private func DrawBlankCell(cell: UIView, prev: UIView? = nil) {
        BodyView.addSubview(cell)
        cell.backgroundColor = YMColors.PanelBackgroundGray
        if(nil != prev) {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 50.LayoutVal(),
                        width: YMSizes.PageWidth, height: 142.LayoutVal())
        } else {
            cell.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 140.LayoutVal(), otherSize: 142.LayoutVal())
        }
    }
    
    public func DrawInfoInputPanel(iconName: String, title: String, cell: UIView) {
        YMLayout.ClearView(view: cell)
        let icon = YMLayout.GetSuitableImageView(iconName)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = YMFonts.YMDefaultFont(36.LayoutVal())
        titleLabel.textColor = YMColors.PatientFontGray
        titleLabel.sizeToFit()
        
        cell.addSubview(icon)
        cell.addSubview(titleLabel)
        
        icon.anchorToEdge(Edge.Left, padding: 100.LayoutVal(), width: icon.width, height: icon.height)
        titleLabel.align(Align.ToTheRightCentered, relativeTo: icon, padding: 160.LayoutVal(),
                         width: titleLabel.width, height: titleLabel.height)
        
        let topBorder = UIView()
        let bottomBorder = UIView()
        
        topBorder.backgroundColor = YMColors.DividerLineGray
        bottomBorder.backgroundColor = YMColors.DividerLineGray
        
        cell.addSubview(topBorder)
        cell.addSubview(bottomBorder)
        
        topBorder.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        bottomBorder.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
    }
    
    private func DrawHint() {
        let hintLabel = UILabel()
        hintLabel.text = "完善以下信息，预约医生更方便"
        hintLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        hintLabel.textColor = YMColors.PatientFontGray
        hintLabel.sizeToFit()
        
        BodyView.addSubview(hintLabel)
        hintLabel.anchorToEdge(Edge.Top, padding: 60.LayoutVal(), width: hintLabel.width, height: hintLabel.height)
    }
    
    private func DrawCells() {
        GenderCell = YMLayout.GetTouchableView(useObject: InfoActions!, useMethod: "GenderTouched:".Sel())
        BirthdayCell = YMLayout.GetTouchableView(useObject: InfoActions!, useMethod: "BirthdayTouched:".Sel())
        CityCell = YMLayout.GetTouchableView(useObject: InfoActions!, useMethod: "CityTouched:".Sel())
        
        DrawBlankCell(GenderCell!)
        DrawBlankCell(BirthdayCell!, prev: GenderCell)
//        DrawBlankCell(CityCell!, prev: BirthdayCell)
        
        
        DrawInfoInputPanel("RegisterInputGender", title: "选择性别", cell: GenderCell!)
        DrawInfoInputPanel("RegisterInputBirthday", title: "选择生日", cell: BirthdayCell!)
//        DrawInfoInputPanel("RegisterInputCity", title: "选择城市", cell: CityCell!)
    }
    
    public func UpdateGender(gender: String, genderNumType: String) {
        DrawInfoInputPanel("RegisterInputGender", title: gender, cell: GenderCell!)
        PageRegisterInputInfoBodyView.InfoList["gender"] = genderNumType
        VerifyInputComplete()

    }
    
    public func UpdateBirthday(birthday: NSDate) {
        DrawInfoInputPanel("RegisterInputBirthday",
                           title: "\(birthday.year)-\(birthday.month)-\(birthday.day)",
                           cell: BirthdayCell!)
        PageRegisterInputInfoBodyView.InfoList["birthdayDate"] = birthday//"\(birthday.year)-\(birthday.month)-\(birthday.day)"
        PageRegisterInputInfoBodyView.InfoList["birthday"] = "\(birthday.year)-\(birthday.month)-\(birthday.day)"
        
        VerifyInputComplete()
    }
    
    private func VerifyInputComplete() {
        if(nil == PageRegisterInputInfoBodyView.InfoList["birthday"]) {
            return
        }
        
        if(nil == PageRegisterInputInfoBodyView.InfoList["gender"]) {
            return
        }
        
        SetConfirmButtonEnable()
    }
}




























