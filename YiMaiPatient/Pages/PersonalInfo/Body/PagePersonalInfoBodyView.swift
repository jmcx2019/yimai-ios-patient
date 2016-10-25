//
//  PagePersonalInfoBodyView.swift
//  YiMaiPatient
//
//  Created by superxing on 16/10/24.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PagePersonalInfoBodyView: PageBodyView {
    var InfoActions: PagePersonalInfoActions!
    var PhotoPikcer: YMPhotoSelector? = nil
    
    var HeadImg: YMTouchableImageView!


    override func ViewLayout() {
        super.ViewLayout()
        
        InfoActions = PagePersonalInfoActions(navController: self.NavController!, target: self)
        DrawFullBody()
        PhotoPikcer = YMPhotoSelector(nav: self.NavController!, maxSelection: 1)
        PhotoPikcer?.SelectedCallback = InfoActions!.HeadImagesSelected
    }
    
    func DrawCell(title: String, content: String, act: Selector, showArr: Bool, prev: UIView) -> YMTouchableView {
        let titleLabel = YMLayout.GetNomalLabel(title, textColor: YMColors.PatientFontGray, fontSize: 28.LayoutVal())
        let contentLabel = YMLayout.GetNomalLabel(content, textColor: YMColors.PatientFontGreen, fontSize: 28.LayoutVal())
        let arrowIcon = YMLayout.GetSuitableImageView("PageIndexSideBarArrowIcon")
        
        let cell = YMLayout.GetTouchableView(useObject: InfoActions, useMethod: act)
        BodyView.addSubview(cell)
        
        cell.align(Align.UnderMatchingLeft, relativeTo: prev, padding: 0, width: YMSizes.PageWidth, height: 70.LayoutVal())
        
        cell.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)

        if(showArr) {
            cell.addSubview(arrowIcon)
            cell.addSubview(contentLabel)
            
            arrowIcon.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrowIcon.width, height: arrowIcon.height)
            contentLabel.align(Align.ToTheLeftCentered, relativeTo: arrowIcon, padding: 20.LayoutVal(), width: contentLabel.width, height: contentLabel.height)
        } else {
            cell.addSubview(contentLabel)
            contentLabel.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: contentLabel.width, height: contentLabel.height)
        }
        
        let borderBottom = UIView()
        borderBottom.backgroundColor = YMColors.PatientBorderDarkGray
        cell.addSubview(borderBottom)
        borderBottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        return cell

    }
    
    func DrawHeadImgCell(headurl: String, updateUserHead: Bool = false) -> UIView {
        let headPanel = UIView()
        let titleLabel = YMLayout.GetNomalLabel("头像", textColor: YMColors.PatientFontGray, fontSize: 28.LayoutVal())
        let contentLabel = YMLayout.GetNomalLabel("请上传", textColor: YMColors.PatientFontGreen, fontSize: 28.LayoutVal())
        let arrowIcon = YMLayout.GetSuitableImageView("PageIndexSideBarArrowIcon")
        HeadImg = YMLayout.GetTouchableImageView(useObject: InfoActions, useMethod: "HeadImgTouched:".Sel(), imageName: "PagePersonalInfoUserheadBkg")
        
        let cell = YMLayout.GetTouchableView(useObject: InfoActions, useMethod: "ChangeHeadImage:".Sel())
        BodyView.addSubview(headPanel)
        headPanel.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 140.LayoutVal())
        
        headPanel.addSubview(cell)
        cell.fillSuperview()
        
        cell.addSubview(titleLabel)
        titleLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        
        headPanel.addSubview(HeadImg)
        HeadImg.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: HeadImg.width, height: HeadImg.height)
        YMLayout.LoadImageFromServer(HeadImg, url: headurl, fullUrl: nil, makeItRound: true, refresh: updateUserHead)

        HeadImg.hidden = true
        if(YMValueValidator.IsEmptyString(headurl)) {
            cell.addSubview(contentLabel)
            cell.addSubview(arrowIcon)
            
            arrowIcon.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrowIcon.width, height: arrowIcon.height)
            contentLabel.align(Align.ToTheLeftCentered, relativeTo: arrowIcon, padding: 20.LayoutVal(), width: contentLabel.width, height: contentLabel.height)
        } else {
            HeadImg.hidden = false
        }
        
        let borderBottom = UIView()
        borderBottom.backgroundColor = YMColors.PatientBorderDarkGray
        headPanel.addSubview(borderBottom)
        borderBottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        return headPanel
    }
    
    func DrawFullBody(updateUserHead: Bool = false) {
        let headurl = YMVar.GetOptionalValAsString(YMVar.MyInfo["head_url"])
        let name = YMVar.GetOptionalValAsString(YMVar.MyInfo["name"])
        var sex = YMVar.GetOptionalValAsString(YMVar.MyInfo["sex"])
        let phone = YMVar.GetOptionalValAsString(YMVar.MyInfo["phone"])
        let birthday = YMVar.GetOptionalValAsString(YMVar.MyInfo["birthday"])
        
        if("0" == sex) {
            sex = "女"
        } else {
            sex = "男"
        }
        
        var prev = DrawHeadImgCell(headurl, updateUserHead: updateUserHead)
        
        print(YMVar.MyInfo)
        
        prev = DrawCell("账号", content: phone, act: PageJumpActions.DoNothingSel, showArr: false, prev: prev)
        prev = DrawCell("姓名", content: name, act: PageJumpActions.DoNothingSel, showArr: true, prev: prev)
        prev = DrawCell("性别", content: sex, act: "GenderTouched:".Sel(), showArr: true, prev: prev)
        prev = DrawCell("出生日期", content: birthday, act: "BirthdayTouched:".Sel(), showArr: true, prev: prev)
    }
    
    func UpdateBirthday(birthday: NSDate) -> String {
        let str = "\(birthday.year)-\(birthday.month)-\(birthday.day)"
        YMVar.MyInfo["birthday"] = str
        
        DrawFullBody()
        
        return str
    }
    
    func UpdateGender(gender: String, genderNumType: String) {
        YMVar.MyInfo["sex"] = genderNumType
        DrawFullBody()
    }
    
    func UpdateUserHead() {
//        HeadImg.image = headImg
//        FullPageLoading.Show()
        DrawFullBody(true)
    }
}







