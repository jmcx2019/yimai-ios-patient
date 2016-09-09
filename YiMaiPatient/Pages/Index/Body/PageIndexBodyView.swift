//
//  PageIndexBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageIndexBodyView: PageBodyView {
    var IndexActions: PageIndexActions? = nil
    let ScrollBannerPanel = UIScrollView()
    let BtnGroupPanel = UIView()
    let MsgPanel = UIView()

    let SideBar = UIScrollView()
    var MainPageMask: YMTouchableView? = nil

    var TopView: UIView? = nil

    var MessageNotifyCell: YMTouchableView? = nil

    override func ViewLayout() {
        super.ViewLayout()
        IndexActions = PageIndexActions(navController: self.NavController!, target: self)

        ParentView?.backgroundColor = YMColors.BackgroundGray
        DrawBannerScrollPanel()
        DrawButtonGroup()
        DrawMsgPanel()
    }
    
    func DrawBannerScrollPanel() {
        BodyView.addSubview(ScrollBannerPanel)
        
        ScrollBannerPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 520.LayoutVal())
        
        let img = YMLayout.GetSuitableImageView("TEMP_INDEX_BANNER")
        ScrollBannerPanel.addSubview(img)
        img.fillSuperview()
    }
    
    func DrawButtonGroup() {
        BodyView.addSubview(BtnGroupPanel)
        BtnGroupPanel.align(Align.UnderMatchingLeft, relativeTo: ScrollBannerPanel, padding: 0, width: YMSizes.PageWidth, height: 200.LayoutVal())
        BtnGroupPanel.backgroundColor = YMColors.White
        
        let searchBtn = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "SearchButtonTouched:".Sel())
        let admissionBtn = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "AdmissionButtonTouched:".Sel())
        let appointmentBtn = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "AppointmentButtonTouched:".Sel())
        
        BtnGroupPanel.addSubview(searchBtn)
        BtnGroupPanel.addSubview(admissionBtn)
        BtnGroupPanel.addSubview(appointmentBtn)
        
        BtnGroupPanel.backgroundColor = YMColors.PatientBorderGray
        BtnGroupPanel.groupAndFill(group: Group.Horizontal, views: [searchBtn, admissionBtn, appointmentBtn], padding: YMSizes.OnPx)
        
        func BuildGroupButton(btn: UIView, text: String, iconName: String, showRightBorder: Bool = true) {
            let icon = YMLayout.GetSuitableImageView(iconName)
            let label = UILabel()
            label.text = text
            label.font = YMFonts.YMDefaultFont(28.LayoutVal())
            label.textColor = YMColors.PatientFontGray
            label.sizeToFit()
            
            btn.addSubview(icon)
            btn.addSubview(label)
            
            icon.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: icon.width, height: icon.height)
            label.anchorToEdge(Edge.Bottom, padding: 40.LayoutVal(), width: label.width, height: label.height)
        }
        
        BuildGroupButton(searchBtn, text: "找专家", iconName: "PageIndexSearchBtn")
        BuildGroupButton(admissionBtn, text: "约我的医生", iconName: "PageIndexAdmissionBtn")
        BuildGroupButton(appointmentBtn, text: "约诊记录", iconName: "PageIndexAppoinmentBtn")
    }
    
    func DrawMsgPanel() {
        BodyView.addSubview(MsgPanel)
        MsgPanel.align(Align.UnderMatchingLeft, relativeTo: BtnGroupPanel, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 0, offset: 0)
        
        MessageNotifyCell = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "MessageNotifyTouched:".Sel())
        MsgPanel.addSubview(MessageNotifyCell!)
        MessageNotifyCell?.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 70.LayoutVal())
        
        let leftIcon = YMLayout.GetSuitableImageView("PageIndexMessageIcon")
        let label = UILabel()
        label.text = "暂无消息"
        label.textColor = YMColors.PatientFontGray
        label.font = YMFonts.YMDefaultFont(24.LayoutVal())
        label.sizeToFit()
        
        let rightIcon = YMLayout.GetSuitableImageView("PageIndexMoreMessaageArrowIcon")
        
        MessageNotifyCell?.addSubview(leftIcon)
        MessageNotifyCell?.addSubview(label)
        MessageNotifyCell?.addSubview(rightIcon)
        
        leftIcon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: leftIcon.width, height: leftIcon.height)
        rightIcon.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: rightIcon.width, height: rightIcon.height)
        label.align(Align.ToTheRightCentered, relativeTo: leftIcon, padding: 14.LayoutVal(), width: label.width, height: label.height)
        
        YMLayout.SetViewHeightByLastSubview(MsgPanel, lastSubView: MessageNotifyCell!)
    }
    
    public func DrawTopBtn(topView: UIView) {
        let userBtn = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "PersonalSettingTouched:".Sel())
        let userIcon = YMLayout.GetSuitableImageView("PageIndexPersonalSettingBtn")
        userBtn.backgroundColor = YMColors.None
        
        topView.addSubview(userBtn)
        userBtn.anchorInCorner(Corner.BottomLeft, xPad: 0, yPad: 0, width: 90.LayoutVal(), height: 90.LayoutVal())
        userBtn.addSubview(userIcon)
        userIcon.anchorInCenter(width: userIcon.width, height: userIcon.height)
        
        
        let qrBtn = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "QRScanTouched:".Sel())
        let qrIcon = YMLayout.GetSuitableImageView("PageIndexScanBtn")
        qrBtn.backgroundColor = YMColors.None

        
        topView.addSubview(qrBtn)
        qrBtn.anchorInCorner(Corner.BottomRight, xPad: 0, yPad: 0, width: 90.LayoutVal(), height: 90.LayoutVal())
        qrBtn.addSubview(qrIcon)
        qrIcon.anchorInCenter(width: qrIcon.width, height: qrIcon.height)
        
        TopView = topView
    }
    
    public func DrawSideBar() {
        MainPageMask = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "MainPageMaskTouched:".Sel())
        MainPageMask?.backgroundColor = YMColors.None
        self.ParentView?.addSubview(MainPageMask!)
        MainPageMask?.fillSuperview()
        MainPageMask?.hidden = true
        
        self.ParentView!.addSubview(SideBar)
        SideBar.anchorToEdge(Edge.Left, padding: -540.LayoutVal(), width: 540.LayoutVal(), height: YMSizes.PageHeight)
        
        let userHead = YMLayout.GetSuitableImageView("PageIndexUserheadBkg")
        SideBar.addSubview(userHead)
        userHead.anchorToEdge(Edge.Top, padding: YMSizes.PageTopHeight, width: userHead.width, height: userHead.height)
        
        let userNameLabel = UILabel()
        let userPhone = UILabel()
        
        userNameLabel.text = "测试用户" //TODO: YMVar.MyInfo[name] as? String
        userNameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        userNameLabel.textColor = YMColors.PatientFontDarkGray
        userNameLabel.sizeToFit()
        
        userPhone.text = YMVar.MyInfo["phone"] as? String
        userPhone.font = YMFonts.YMDefaultFont(28.LayoutVal())
        userPhone.textColor = YMColors.PatientFontGreen
        userPhone.sizeToFit()
        
        SideBar.addSubview(userNameLabel)
        SideBar.addSubview(userPhone)
        
        userNameLabel.align(Align.UnderCentered, relativeTo: userHead, padding: 20.LayoutVal(), width: userNameLabel.width, height: userNameLabel.height)
        userPhone.align(Align.UnderCentered, relativeTo: userNameLabel, padding: 18.LayoutVal(), width: userPhone.width, height: userPhone.height)
        
        let menuPanel = UIView()
        
        SideBar.addSubview(menuPanel)
        menuPanel.align(Align.UnderCentered, relativeTo: userPhone, padding: 60.LayoutVal(), width: 540.LayoutVal(), height: 450.LayoutVal())
        
        let myDoc = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "MyDocTouched:".Sel())
        let myWallet = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "MyWalletTouched:".Sel())
        let broadcast = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "BroadcastTouched:".Sel())
        let about = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "AboutTouched:".Sel())
        let healthZone = YMLayout.GetTouchableView(useObject: IndexActions!, useMethod: "HealthZoneTouched:".Sel())
        
        menuPanel.addSubview(myDoc)
        menuPanel.addSubview(myWallet)
        menuPanel.addSubview(broadcast)
        menuPanel.addSubview(about)
        menuPanel.addSubview(healthZone)
        
        menuPanel.backgroundColor = YMColors.PatientBorderDarkGray
        menuPanel.groupAndFill(group: Group.Vertical, views: [myDoc, myWallet, broadcast, about, healthZone], padding: YMSizes.OnPx)
        
        func BuildMenuEntry(entry: UIView, text: String, iconName: String) {
            let label = UILabel()
            let icon = YMLayout.GetSuitableImageView(iconName)
            let arrIcon = YMLayout.GetSuitableImageView("PageIndexSideBarArrowIcon")
            
            label.text = text
            label.textColor = YMColors.PatientFontDarkGray
            label.font = YMFonts.YMDefaultFont(28.LayoutVal())
            label.sizeToFit()
            
            entry.addSubview(label)
            entry.addSubview(icon)
            entry.addSubview(arrIcon)
            
            icon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: icon.width, height: icon.height)
            label.anchorToEdge(Edge.Left, padding: 90.LayoutVal(), width: label.width, height: label.height)
            arrIcon.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrIcon.width, height: arrIcon.height)
            
            entry.backgroundColor = YMColors.BackgroundGray
        }
        
        BuildMenuEntry(myDoc, text: "我的医生", iconName: "PageIndexSideBarMyDocIcon")
        BuildMenuEntry(myWallet, text: "我的钱包", iconName: "PageIndexSideBarMyWalletIcon")
        BuildMenuEntry(broadcast, text: "广播站", iconName: "PageIndexSideBarBroadcastIcon")
        BuildMenuEntry(about, text: "关于 “医脉-看专家”", iconName: "PageIndexSideBarAboutIcon")
        BuildMenuEntry(healthZone, text: "健康合作顾问专区", iconName: "PageIndexSideBarHealthZone")
    }
}






















