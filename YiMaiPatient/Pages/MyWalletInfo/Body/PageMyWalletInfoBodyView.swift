//
//  PageMyWalletInfoBodyView.swift
//  YiMaiPatient
//
//  Created by why on 2017/2/6.
//  Copyright © 2017年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageMyWalletInfoBodyView: PageBodyView {
    var InfoAction: PageMyWalletInfoActions!
    let BigCoin = YMLayout.GetSuitableImageView("BigCoinForWallet")
    let TotalMoneyLabel = YMLayout.GetNomalLabel("0.00", textColor: YMColors.FontGray, fontSize: 120.LayoutVal())
    let TotalMoneyTitle = YMLayout.GetNomalLabel("余额（元）", textColor: YMColors.PatientFontGreen, fontSize: 24.LayoutVal())
    let FreezeLabel = YMLayout.GetNomalLabel("0.00元冻结中", textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
    let FreezeIcon = YMLayout.GetSuitableImageView("WalletFreeseIcon")
    let FreezePanel = YMTouchableView()
    
    let ChargeButton = YMButton()
    let GetMoneyButton = YMButton()
    
    var WalletInfo = [String: AnyObject]()
    var SelectedAppointmentInfo = [String: String]()
    var AppointmentListData = [[String: AnyObject]]()
    
    var AppointmentBox = YMTouchableScrollView()

    override func ViewLayout() {
        super.ViewLayout()

        InfoAction = PageMyWalletInfoActions(navController: NavController!, target: self)
        DrawFullBody()
    }
    
    func DrawButtons() {
        ChargeButton.setTitle("充值", forState: UIControlState.Normal)
        ChargeButton.backgroundColor = YMColors.PatientChargeButtonBkg
        ChargeButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ChargeButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        ChargeButton.layer.cornerRadius = 10.LayoutVal()
        ChargeButton.layer.masksToBounds = true
        ChargeButton.addTarget(InfoAction, action: "Charge:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        BodyView.addSubview(ChargeButton)
        ChargeButton.align(Align.UnderCentered, relativeTo: FreezePanel, padding: 140.LayoutVal(), width: 670.LayoutVal(), height: 80.LayoutVal())
        
//        GetMoneyButton.setTitle("提现", forState: UIControlState.Normal)
//        GetMoneyButton.backgroundColor = YMColors.PatientFontGreen
//        GetMoneyButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
//        GetMoneyButton.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
//        GetMoneyButton.layer.cornerRadius = 10.LayoutVal()
//        GetMoneyButton.layer.masksToBounds = true
//        GetMoneyButton.addTarget(InfoAction, action: "GetMoney:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
//        BodyView.addSubview(GetMoneyButton)
//        GetMoneyButton.align(Align.UnderCentered, relativeTo: ChargeButton, padding: 20.LayoutVal(), width: 670.LayoutVal(), height: 80.LayoutVal())
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ChargeButton, padding: 98.LayoutVal())
    }
    
    func DrawFreezePanel(value: String) {
        YMLayout.ClearView(view: FreezePanel)
        BodyView.addSubview(FreezePanel)

        FreezeLabel.text = "\(value)元冻结中"
        FreezeLabel.sizeToFit()
        
        let panelWidth = FreezeLabel.width + FreezeIcon.width + 10.LayoutVal() +  60.LayoutVal() * 2 + 40.LayoutVal()
        
        FreezePanel.align(Align.UnderCentered, relativeTo: TotalMoneyTitle, padding: 40.LayoutVal(), width: panelWidth, height: 60.LayoutVal())
        
        FreezePanel.backgroundColor = YMColors.FontLighterGray
        FreezePanel.layer.cornerRadius = 30.LayoutVal()
        FreezePanel.layer.masksToBounds = true

        FreezePanel.addSubview(FreezeIcon)
        FreezePanel.addSubview(FreezeLabel)
        
        FreezeIcon.anchorToEdge(Edge.Left, padding: 50.LayoutVal(), width: FreezeIcon.width, height: FreezeIcon.height)
        FreezeLabel.anchorToEdge(Edge.Right, padding: 50.LayoutVal(), width: FreezeLabel.width, height: FreezeLabel.height)
    }
    
    func DrawFullBody() {
        BodyView.addSubview(BigCoin)
        BigCoin.anchorToEdge(Edge.Top, padding: 128.LayoutVal(), width: BigCoin.width, height: BigCoin.height)
        
        BodyView.addSubview(TotalMoneyLabel)
        TotalMoneyLabel.align(Align.UnderCentered, relativeTo: BigCoin, padding: 80.LayoutVal(), width: YMSizes.PageWidth, height: TotalMoneyLabel.height)
        TotalMoneyLabel.textAlignment  = NSTextAlignment.Center
        
        BodyView.addSubview(TotalMoneyTitle)
        TotalMoneyTitle.align(Align.UnderCentered, relativeTo: TotalMoneyLabel, padding: 20.LayoutVal(), width: TotalMoneyTitle.width, height: TotalMoneyTitle.height)
        
        DrawFreezePanel("0.00")
        DrawButtons()
    }
    
    func DrawAppointmentList() {
        BodyView.addSubview(AppointmentBox)
        AppointmentBox.fillSuperview()
        AppointmentBox.backgroundColor = YMColors.OpacityBlackMask
        AppointmentBox.hidden = true
    }
    
    func LoadData(data: [String: AnyObject], loadList: Bool = true) {
        let wallet = data["wallet"] as! [String: AnyObject]
        WalletInfo = wallet
        TotalMoneyLabel.text = YMVar.GetStringByKey(wallet, key: "total")
        DrawFreezePanel(YMVar.GetStringByKey(wallet, key: "freeze"))
        
        if(loadList) {
            let appointmentList = data["appointment_list"] as! [[String: AnyObject]]
            AppointmentListData = appointmentList
            LoadAppointmentBox(AppointmentListData)
        }
    }

    func AppointmentCheckTouched(gr: UIGestureRecognizer) {
        let btn = gr.view as! YMTouchableView
        let cell = btn.UserObjectData as! YMTouchableView
        
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let status = YMVar.GetStringByKey(cellData, key: "status")
        let checkedIcon = cellData["checkedIcon"] as! YMTouchableImageView
        let uncheckedIcon = cellData["unchedkedIcon"] as! YMTouchableImageView
        let id = YMVar.GetStringByKey(cellData, key: "id")

        if("1" == status) {
            uncheckedIcon.hidden = false
            checkedIcon.hidden = true
            
            cellData["status"] = "0"
            SelectedAppointmentInfo[id] = "0"
        } else {
            uncheckedIcon.hidden = true
            checkedIcon.hidden = false
            
            cellData["status"] = "1"
            SelectedAppointmentInfo[id] = id
        }
        
        cell.UserObjectData = cellData
    }
    
    
    func DownArrowTouched(gr: UIGestureRecognizer) {
        let btn = gr.view as! YMTouchableView
        let cell = btn.UserObjectData as! YMTouchableView
        let cellData = cell.UserObjectData as! [String: AnyObject]
        
        let id = YMVar.GetStringByKey(cellData, key: "id")
        
        for (idx, appointment) in AppointmentListData.enumerate() {
            let appointmentId = YMVar.GetStringByKey(appointment, key: "id")
            if(appointmentId == id) {
                AppointmentListData[idx]["expandFlag"] = "1"
                break
            }
        }
        
        LoadAppointmentBox(AppointmentListData)
    }
    
    func UpArrowTouched(gr: UIGestureRecognizer) {
        let btn = gr.view as! YMTouchableView
        let cell = btn.UserObjectData as! YMTouchableView
        let cellData = cell.UserObjectData as! [String: AnyObject]
        
        let id = YMVar.GetStringByKey(cellData, key: "id")
        
        for (idx, appointment) in AppointmentListData.enumerate() {
            let appointmentId = YMVar.GetStringByKey(appointment, key: "id")
            if(appointmentId == id) {
                AppointmentListData[idx].removeValueForKey("expandFlag")
                break
            }
        }
        
        LoadAppointmentBox(AppointmentListData)
    }

    func DrawAppointmentCell(parent: UIView, data: [String: AnyObject], prev: UIView?) -> UIView {
        let cell = YMTouchableView()
        parent.addSubview(cell)
        cell.align(Align.UnderCentered, relativeTo: prev!, padding: 0, width: parent.width, height: 80.LayoutVal())
        cell.layer.masksToBounds = true

        let appointmentId = YMVar.GetStringByKey(data, key: "id")
        let userName = YMVar.GetStringByKey(data, key: "doctor_name")
        let userJobtitle = YMVar.GetStringByKey(data, key: "doctor_job_title", defStr: "医生")
        let userHead = YMVar.GetStringByKey(data, key: "doctor_head_url")
//        let _ = YMVar.GetStringByKey(data, key: "doctor_is_auth")
        let dept = YMVar.GetStringByKey(data, key: "doctor_dept")
        let hos = YMVar.GetStringByKey(data, key: "doctor_hospital")
        let time = YMVar.GetStringByKey(data, key: "time")
        let price = YMVar.GetStringByKey(data, key: "price")
        let deadline = YMVar.GetStringByKey(data, key: "deadline")
        let borderBottom = UIView()
        
        let downBtnPanel = YMLayout.GetTouchableView(useObject: self, useMethod: "DownArrowTouched:".Sel())
        let upBtnPanel = YMLayout.GetTouchableView(useObject: self, useMethod: "UpArrowTouched:".Sel())

        let downBtnIcon = YMLayout.GetSuitableImageView("CommonGrayDownArrowIcon")
        let upBtnIcon = YMLayout.GetSuitableImageView("CommonGrayUpArrowIcon")
        let clockIcon = YMLayout.GetSuitableImageView("CommonClockIcon")
        let checkedIcon = YMLayout.GetTouchableImageView(useObject: self, useMethod: "AppointmentCheckTouched:".Sel(), imageName: "RegisterCheckboxAgreeChecked")
        let uncheckedIcon = YMLayout.GetTouchableImageView(useObject: self, useMethod: "AppointmentCheckTouched:".Sel(), imageName: "RegisterCheckboxAgreeUnchecked")
        
        let cellDivider = UIView()
        let panelDivider = UIView()
        
        borderBottom.backgroundColor = YMColors.PatientBorderDarkGray
        cellDivider.backgroundColor = YMColors.PatientFontGreen
        panelDivider.backgroundColor = YMColors.PatientFontGreen
        
        let userNameCellLabel = YMLayout.GetNomalLabel(userName, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let priceLabel = YMLayout.GetNomalLabel(price + "元", textColor: YMColors.PatientFontGreen, fontSize: 22.LayoutVal())
        let userDeptCellLabel = YMLayout.GetNomalLabel(dept, textColor: YMColors.PatientFontGreen, fontSize: 22.LayoutVal())

        let userNamePanelLabel = YMLayout.GetNomalLabel(userName, textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let userDeptPanelLabel = YMLayout.GetNomalLabel(dept, textColor: YMColors.FontGray, fontSize: 22.LayoutVal())
        let userJobtitleLabel = YMLayout.GetNomalLabel(userJobtitle, textColor: YMColors.FontGray, fontSize: 22.LayoutVal())
        let hosLabel = YMLayout.GetNomalLabel(hos, textColor: YMColors.FontLightGray, fontSize: 24.LayoutVal())
        
        hosLabel.numberOfLines = 3
        hosLabel.frame = CGRect(x: 0, y: 0, width: 400.LayoutVal(), height: 0)
        hosLabel.sizeToFit()

        let timeLabel = YMLayout.GetNomalLabel(time, textColor: YMColors.FontLightGray, fontSize: 24.LayoutVal())
        let deadlineLabel = YMLayout.GetNomalLabel("将于（\(deadline)）过期", textColor: YMColors.FontLightGray, fontSize: 22.LayoutVal())
        
        let checkBtn = YMLayout.GetTouchableView(useObject: self, useMethod: "AppointmentCheckTouched:".Sel())
        checkBtn.backgroundColor = YMColors.None
        
        cell.addSubview(downBtnPanel)
        cell.addSubview(upBtnPanel)
        cell.addSubview(userNameCellLabel)
        cell.addSubview(cellDivider)
        cell.addSubview(userDeptCellLabel)
        cell.addSubview(priceLabel)
        cell.addSubview(checkedIcon)
        cell.addSubview(uncheckedIcon)
        cell.addSubview(checkBtn)
        
        var status = YMVar.GetStringByKey(SelectedAppointmentInfo, key: appointmentId, defStr: "none")
        if("none" == status) {
            SelectedAppointmentInfo[appointmentId] = appointmentId
            status = "1"
            uncheckedIcon.hidden = true
        } else {
            if("0" == status) {
                checkedIcon.hidden = true
            } else {
                status = "1"
                uncheckedIcon.hidden = true
            }
        }
        
        checkedIcon.anchorToEdge(Edge.Left, padding: 30.LayoutVal(), width: checkedIcon.width, height: checkedIcon.height)
        uncheckedIcon.anchorToEdge(Edge.Left, padding: 30.LayoutVal(), width: checkedIcon.width, height: checkedIcon.height)
        userNameCellLabel.align(Align.ToTheRightCentered, relativeTo: checkedIcon, padding: 10.LayoutVal(), width: userNameCellLabel.width, height: userNameCellLabel.height)
        cellDivider.align(Align.ToTheRightCentered, relativeTo: userNameCellLabel, padding: 10.LayoutVal(), width: YMSizes.OnPx, height: 24.LayoutVal())
        userDeptCellLabel.align(Align.ToTheRightCentered, relativeTo: cellDivider, padding: 10.LayoutVal(), width: 140.LayoutVal(), height: userDeptCellLabel.height)
        priceLabel.align(Align.ToTheRightCentered, relativeTo: userDeptCellLabel, padding: 10.LayoutVal(), width: priceLabel.width, height: priceLabel.height)
        downBtnPanel.anchorToEdge(Edge.Right, padding: 0, width: downBtnIcon.width*2 + 30.LayoutVal(), height: cell.height)
        upBtnPanel.anchorToEdge(Edge.Right, padding: 0, width: downBtnIcon.width*2 + 30.LayoutVal(), height: cell.height)
        
        checkBtn.anchorToEdge(Edge.Left, padding: 20.LayoutVal(), width: 50.LayoutVal(), height: 50.LayoutVal())
        
        downBtnPanel.addSubview(downBtnIcon)
        upBtnPanel.addSubview(upBtnIcon)
        
        downBtnIcon.anchorInCenter(width: downBtnIcon.width, height: downBtnIcon.height)
        upBtnIcon.anchorInCenter(width: upBtnIcon.width, height: upBtnIcon.height)
        upBtnPanel.hidden = true
        
        
        let defUserHead = YMLayout.GetSuitableImageView("HeadImageBorder")
        
        cell.addSubview(defUserHead)
        defUserHead.anchorToEdge(Edge.Top, padding: 85.LayoutVal(), width: defUserHead.width, height: defUserHead.height)
        YMLayout.LoadImageFromServer(defUserHead, url: userHead, isDocImg: true, fullUrl: nil, makeItRound: true, refresh: false)
        
        cell.addSubview(userNamePanelLabel)
        cell.addSubview(userDeptPanelLabel)
        cell.addSubview(userJobtitleLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(deadlineLabel)
        cell.addSubview(panelDivider)
        cell.addSubview(clockIcon)
        
        panelDivider.align(Align.UnderCentered, relativeTo: defUserHead, padding: 20.LayoutVal(), width: YMSizes.OnPx, height: 24.LayoutVal())
        userNamePanelLabel.align(Align.ToTheLeftCentered, relativeTo: panelDivider, padding: 10.LayoutVal(), width: userNamePanelLabel.width, height: userNamePanelLabel.height)
        userJobtitleLabel.align(Align.ToTheRightCentered, relativeTo: panelDivider, padding: 10.LayoutVal(), width: userJobtitleLabel.width, height: userJobtitleLabel.height)
        userDeptPanelLabel.align(Align.UnderCentered, relativeTo: panelDivider, padding: 18.LayoutVal(), width: userDeptPanelLabel.width, height: userDeptPanelLabel.height)
        timeLabel.align(Align.UnderCentered, relativeTo: userDeptPanelLabel, padding: 12.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        clockIcon.align(Align.ToTheLeftCentered, relativeTo: timeLabel, padding: 10.LayoutVal(), width: clockIcon.width, height: clockIcon.height)
        deadlineLabel.align(Align.UnderCentered, relativeTo: timeLabel, padding: 12.LayoutVal(), width: deadlineLabel.width, height: deadlineLabel.height)
        
        let highlightType = ActiveType.Custom(pattern: deadline)
        deadlineLabel.enabledTypes = [highlightType]
        deadlineLabel.customColor[highlightType] = YMColors.NotifyFlagOrange
        deadlineLabel.text = deadlineLabel.text
        
        var expandFlag = false
        for appointment in AppointmentListData {
            let id = YMVar.GetStringByKey(appointment, key: "id")
            if(appointmentId == id) {
                let expand = appointment["expandFlag"] as? String
                
                if(nil != expand) {
                    expandFlag = true
                    break
                }
            }
        }
        
        if(expandFlag) {
            downBtnPanel.hidden = true
            upBtnPanel.hidden = false
            YMLayout.SetViewHeightByLastSubview(cell, lastSubView: timeLabel, bottomPadding: 98.LayoutVal())
        } else {
            downBtnPanel.hidden = false
            upBtnPanel.hidden = true
        }
        cell.addSubview(borderBottom)
        borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: 420.LayoutVal(), height: YMSizes.OnPx)
        
        cell.UserObjectData = ["border": borderBottom, "lastView": deadlineLabel, "checkedIcon": checkedIcon,
                               "unchedkedIcon": uncheckedIcon, "id": appointmentId, "status": status]
        
        checkBtn.UserObjectData = cell
        downBtnPanel.UserObjectData = cell
        upBtnPanel.UserObjectData = cell

        return cell
    }
    
    func LoadAppointmentBox(data: [[String: AnyObject]]) {
        DrawAppointmentList()
        YMLayout.ClearView(view: AppointmentBox)
        
        if(0 == data.count) {
            HideAppointmentBox()
            return
        }
        let innerBox = UIView()
        
        innerBox.backgroundColor = YMColors.White
        innerBox.layer.cornerRadius = 20.LayoutVal()
        innerBox.layer.masksToBounds = true

        AppointmentBox.UserObjectData = innerBox
        AppointmentBox.addSubview(innerBox)
        innerBox.anchorToEdge(Edge.Top, padding: 100.LayoutVal(), width: 480.LayoutVal(), height: 0)
        
        let titleView = UIView()
        let borderBottom = UIView()
        let titleLabel = YMLayout.GetNomalLabel("您有以下待缴纳保证金", textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        
        borderBottom.backgroundColor = YMColors.PatientBorderDarkGray
        innerBox.addSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(borderBottom)
        
        titleView.anchorToEdge(Edge.Top, padding: 0, width: innerBox.width, height: 80.LayoutVal())
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
        borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: innerBox.width, height: YMSizes.OnPx)
        
        var prev: UIView = titleView
        for appointment in data {
            prev = DrawAppointmentCell(innerBox,data: appointment, prev: prev)
        }
        
//        let closeBtn = YMLayout.GetTouchableImageView(useObject: self, useMethod: "CloseAppointmentList:".Sel(), imageName: "YMCloseBtnGray")
//        titleView.addSubview(closeBtn)
//        closeBtn.anchorToEdge(Edge.Right, padding: 30.LayoutVal(), width: closeBtn.width / 2, height: closeBtn.height / 2)
        
        let btnPanel = UIView()
        
        let divider = UIView()
        
        let payBtn = YMButton()
        let cancelBtn = YMButton()
        
        innerBox.addSubview(btnPanel)
        btnPanel.align(Align.UnderCentered, relativeTo: prev, padding: 0, width: innerBox.width, height: 80.LayoutVal())
        
        btnPanel.addSubview(payBtn)
        btnPanel.addSubview(cancelBtn)
        btnPanel.addSubview(divider)
        
        payBtn.setTitle("缴纳", forState: UIControlState.Normal)
        payBtn.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
        payBtn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        payBtn.addTarget(self, action: "PayList:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        cancelBtn.setTitle("以后再说", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(YMColors.FontGray, forState: UIControlState.Normal)
        cancelBtn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        cancelBtn.addTarget(self, action: "CloseAppointmentList:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        divider.anchorInCenter(width: YMSizes.OnPx, height: btnPanel.height)
        btnPanel.groupAndFill(group: Group.Horizontal, views: [payBtn, cancelBtn], padding: 0)
        
        YMLayout.SetViewHeightByLastSubview(innerBox, lastSubView: btnPanel)
        YMLayout.SetVScrollViewContentSize(AppointmentBox, lastSubView: innerBox, padding: 200.LayoutVal())
        
        ShowAppointmentBox()
    }
    
    func PayList(sender: YMButton) {
        print("PayList")
        if(0 == SelectedAppointmentInfo.count) {
            YMPageModalMessage.ShowErrorInfo("请至少选中一个约诊进行付款。", nav: NavController!)
            return
        }
        
        var idList = [String]()
        for (_,v) in SelectedAppointmentInfo {
            if("0" != v) {
                idList.append(v)
            }
        }
        
        if(0 == idList.count) {
            YMPageModalMessage.ShowErrorInfo("请至少选中一个约诊进行付款。", nav: NavController!)
            return
        }


        FullPageLoading.Show()
        
        InfoAction.PayListApi.YMPayFromWalletForList(idList.joinWithSeparator(","))
//        InfoAction.ChargeApi
    }
    
    func CloseAppointmentList(_: AnyObject) {
        HideAppointmentBox()
    }
    
    func ShowAppointmentBox() {
        AppointmentBox.hidden = false
    }
    
    func HideAppointmentBox() {
        AppointmentBox.hidden = true
    }
    
    func Clear() {
        AppointmentListData.removeAll()
        SelectedAppointmentInfo.removeAll()
        HideAppointmentBox()
    }
}




















