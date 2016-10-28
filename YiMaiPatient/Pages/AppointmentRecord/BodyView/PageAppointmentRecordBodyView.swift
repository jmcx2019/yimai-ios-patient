//
//  PageAppointmentRecordBodyView.swift
//  YiMaiPatient
//
//  Created by superxing on 16/10/21.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageAppointmentRecordBodyView: PageBodyView {
    var RecordActions: PageAppointmentRecordActions!
    
    var TabBarPanel = UIView()
    
    var WaitForConfirmTab: YMTouchableView!
    var WaitForDiagnosisTab: YMTouchableView!
    var AlreadyCompletedTab: YMTouchableView!
    
    var AppointmentList: [String: [[String: AnyObject]]]? = nil
    
    var ListPanel = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        RecordActions = PageAppointmentRecordActions(navController: self.NavController, target: self)
        DrawFullBody()
        
        FullPageLoading.Show()
    }
    
    func DrawFullBody() {
        DrawTabBar()
        
        BodyView.addSubview(ListPanel)
        ListPanel.align(Align.UnderMatchingLeft, relativeTo: TabBarPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
    }
    
    
    func DrawTabBar() {
        WaitForConfirmTab = YMLayout.GetTouchableView(useObject: RecordActions, useMethod: "WaitForConfirmTabTouched:".Sel())
        WaitForDiagnosisTab = YMLayout.GetTouchableView(useObject: RecordActions, useMethod: "WaitForDiagnosisTabTouched:".Sel())
        AlreadyCompletedTab = YMLayout.GetTouchableView(useObject: RecordActions, useMethod: "AlreadyCompletedTabTouched:".Sel())
        
        BodyView.addSubview(TabBarPanel)
        TabBarPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 80.LayoutVal())
        
        TabBarPanel.addSubview(WaitForConfirmTab)
        TabBarPanel.addSubview(WaitForDiagnosisTab)
        TabBarPanel.addSubview(AlreadyCompletedTab)

        TabBarPanel.groupAndFill(group: Group.Horizontal, views: [WaitForConfirmTab, WaitForDiagnosisTab, AlreadyCompletedTab], padding: 0)
        
        func FillTab(tab: YMTouchableView, title: String) {
            tab.backgroundColor = YMColors.PatientTabBackgroundGray

            let titleLabel = YMLayout.GetNomalLabel(title, textColor: YMColors.PatientFontGray, fontSize: 30.LayoutVal())
            
            tab.addSubview(titleLabel)
            titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
            
            let indc = UIView()
            indc.backgroundColor = YMColors.PatientFontGreen
            tab.addSubview(indc)
            
            indc.anchorToEdge(Edge.Bottom, padding: 0, width: 130.LayoutVal(), height: 4.LayoutVal())
            indc.hidden = true
            
            tab.UserObjectData = ["label": titleLabel, "indc": indc]
        }
        
        FillTab(WaitForConfirmTab, title: "待确认")
        FillTab(WaitForDiagnosisTab, title: "待面诊")
        FillTab(AlreadyCompletedTab, title: "已经结束")
        
        let divider1 = UIView()
        let divider2 = UIView()
        
        divider1.backgroundColor = YMColors.PatientFontGreen
        divider2.backgroundColor = YMColors.PatientFontGreen
        
        TabBarPanel.addSubview(divider1)
        TabBarPanel.addSubview(divider2)
        
        divider1.anchorToEdge(Edge.Left, padding: 250.LayoutVal(), width: YMSizes.OnPx, height: 30.LayoutVal())
        divider2.anchorToEdge(Edge.Left, padding: 500.LayoutVal(), width: YMSizes.OnPx, height: 30.LayoutVal())
    }
    
    func ShowWaitForConfirm() {
        SetTabSelected(WaitForConfirmTab)
        if(nil == AppointmentList) {
            return
        }
        let listData = AppointmentList!["wait_confirm"]!
        DrawList(listData)
    }
    
    func ShowWaitForDiagnosis() {
        SetTabSelected(WaitForDiagnosisTab)
        if(nil == AppointmentList) {
            return
        }
        let listData = AppointmentList!["wait_meet"]!
        DrawList(listData)
    }
    
    func ShowAlreadyCompleted() {
        SetTabSelected(AlreadyCompletedTab)
        if(nil == AppointmentList) {
            return
        }
        let listData = AppointmentList!["completed"]!
        DrawList(listData)
    }
    
    func ResetAllTab() {
        func ResetTabSelectedStyle(tab: YMTouchableView) {
            let tabCtrls = tab.UserObjectData as! [String: AnyObject]
            
            let label = tabCtrls["label"] as! UILabel
            let indc = tabCtrls["indc"] as! UIView
            
            label.textColor = YMColors.PatientFontGray
            indc.hidden = true
        }
        
        ResetTabSelectedStyle(WaitForConfirmTab)
        ResetTabSelectedStyle(WaitForDiagnosisTab)
        ResetTabSelectedStyle(AlreadyCompletedTab)
    }
    
    func SetTabSelected(tab: YMTouchableView) {
        ResetAllTab()
        
        let tabCtrls = tab.UserObjectData as! [String: AnyObject]
        
        let label = tabCtrls["label"] as! UILabel
        let indc = tabCtrls["indc"] as! UIView
        
        label.textColor = YMColors.PatientFontGreen
        indc.hidden = false
    }
    
    func DrawList(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: ListPanel)
        ListPanel.align(Align.UnderMatchingLeft, relativeTo: TabBarPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ListPanel)
        
        if(0 == data.count) {
            return
        }

        func BuildCell(data: [String: AnyObject], prev: YMTouchableView?) -> YMTouchableView? {
            let dHeadurl = YMVar.GetOptionalValAsString(data["doctor_head_url"])
            let dNameStr = YMVar.GetOptionalValAsString(data["doctor_name"])
            let dJobtitleStr = YMVar.GetOptionalValAsString(data["doctor_job_title"])
            let pNameStr = YMVar.GetOptionalValAsString(data["patient_name"])
            let pAgeStr = YMVar.GetOptionalValAsString(data["patient_age"])
            let pSexStr = YMVar.GetOptionalValAsString(data["patient_sex"])
            let statusStr = YMVar.GetOptionalValAsString(data["status"])
            let timeStr = YMVar.GetOptionalValAsString(data["time"])
            let modeStr = YMVar.GetOptionalValAsString(data["request_mode"])
            
            if(YMValueValidator.IsEmptyString(dNameStr)) {
                return prev
            }
            
            let cell = YMLayout.GetTouchableView(useObject: RecordActions, useMethod: "CellTouched:".Sel())
            
            ListPanel.addSubview(cell)
            if(nil == prev) {
                cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
            } else {
                cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
            }
            
//            deposit = "<null>";
//            "doctor_head_url" = "/uploads/avatar/1.jpg";
//            "doctor_id" = 1;
//            "doctor_is_auth" = 0;
//            "doctor_job_title" = "\U4e3b\U4efb\U533b\U5e08";
//            "doctor_name" = "\U53ea";
//            id = 991610100001;
//            "patient_age" = 21;
//            "patient_id" = 2;
//            "patient_name" = 1;
//            "patient_sex" = 0;
//            price = "300.00";
//            "request_mode" = "\U627e\U4e13\U5bb6";
//            status = "\U4fdd\U8bc1\U91d1\U4ee3\U7f34";
//            time = " \U4e0b\U5348";
            
            var pInfoStr = pNameStr
            if(!YMValueValidator.IsEmptyString(pSexStr)) {
                if("0" == pSexStr) {
                    pInfoStr += " 女"
                } else {
                    pInfoStr += " 男"
                }
            }
            
            if(!YMValueValidator.IsEmptyString(pAgeStr)) {
                pInfoStr += " \(pAgeStr)"
            }
            
            cell.UserObjectData = data
            
            let docHead = YMLayout.GetSuitableImageView("HeadImageBorder")
            let dName = YMLayout.GetNomalLabel(dNameStr,textColor: YMColors.PatientFontDarkGray, fontSize: 30.LayoutVal())
            let dJobtitle = YMLayout.GetNomalLabel(dJobtitleStr,textColor: YMColors.PatientFontDarkGray, fontSize: 22.LayoutVal())
            let pTitle = YMLayout.GetNomalLabel("患者",textColor: YMColors.PatientFontDarkGray, fontSize: 22.LayoutVal())
            let pInfo = YMLayout.GetNomalLabel(pInfoStr,textColor: YMColors.PatientFontDarkGray, fontSize: 22.LayoutVal())
            let status = YMLayout.GetNomalLabel(statusStr,textColor: YMColors.PatientFontGreen, fontSize: 24.LayoutVal())
            let time = YMLayout.GetNomalLabel(timeStr,textColor: YMColors.PatientFontDarkGray, fontSize: 22.LayoutVal())
            let mode = YMLayout.GetNomalLabel(modeStr,textColor: YMColors.PatientFontGreen, fontSize: 22.LayoutVal())
            
            let pIcon = YMLayout.GetSuitableImageView("AppointmentListIconPatient")
            let tIcon = YMLayout.GetSuitableImageView("AppointmentListIconTime")
            
            cell.addSubview(docHead)
            docHead.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                                 width: docHead.width, height: docHead.height)
            if(!YMValueValidator.IsEmptyString(dHeadurl)) {
                YMLayout.LoadImageFromServer(docHead, url: dHeadurl, fullUrl: nil, makeItRound: true)
            }
            
            cell.addSubview(dName)
            dName.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 30.LayoutVal(),
                                 width: dName.width, height: dName.height)
            if(!YMValueValidator.IsEmptyString(dJobtitleStr)) {
                let dd = UIView()
                cell.addSubview(dd)
                cell.addSubview(dJobtitle)
                
                dd.align(Align.ToTheRightCentered, relativeTo: dName, padding: 16.LayoutVal(),
                        width: YMSizes.OnPx, height: 20.LayoutVal())
                dd.backgroundColor = YMColors.PatientFontDarkGray
                dJobtitle.align(Align.ToTheRightCentered, relativeTo: dd, padding: 16.LayoutVal(),
                                width: dJobtitle.width, height: dJobtitle.height)
            } else {
                dJobtitle.align(Align.ToTheRightCentered, relativeTo: dName, padding: 16.LayoutVal(),
                                width: 0, height: dJobtitle.height)
            }
            
            cell.addSubview(pIcon)
            cell.addSubview(pTitle)
            
            pIcon.align(Align.UnderMatchingLeft, relativeTo: dName, padding: 12.LayoutVal(), width: pIcon.width, height: pIcon.height)
            pTitle.align(Align.ToTheRightCentered, relativeTo: pIcon, padding: 12.LayoutVal(), width: pTitle.width, height: pTitle.height)
            
            let pd = UIView()
            cell.addSubview(pd)
            pd.align(Align.ToTheRightCentered, relativeTo: pTitle, padding: 16.LayoutVal(),
                     width: YMSizes.OnPx, height: 20.LayoutVal())
            pd.backgroundColor = YMColors.PatientFontDarkGray
            cell.addSubview(pInfo)
            pInfo.align(Align.ToTheRightCentered, relativeTo: pd, padding: 16.LayoutVal(),
                        width: pd.width, height: pd.height)
            
            cell.addSubview(tIcon)
            cell.addSubview(time)
            tIcon.align(Align.UnderMatchingLeft, relativeTo: pIcon, padding: 12.LayoutVal(),
                        width: tIcon.width, height: tIcon.height)
            time.align(Align.ToTheRightCentered, relativeTo: tIcon,
                       padding: 12.LayoutVal(), width: time.width, height: time.height)
            
            if(!YMValueValidator.IsEmptyString(modeStr)) {
                cell.addSubview(mode)
                mode.textAlignment = NSTextAlignment.Center
                mode.align(Align.ToTheRightCentered, relativeTo: dJobtitle,
                           padding: 16.LayoutVal(), width: 106.LayoutVal(), height: 30.LayoutVal())
                mode.layer.borderColor = YMColors.PatientFontGreen.CGColor
                mode.layer.borderWidth = YMSizes.OnPx
                mode.layer.cornerRadius = 10.LayoutVal()
                mode.layer.masksToBounds = true
            }
            
            cell.addSubview(status)
            status.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 35.LayoutVal(),
                                  width: status.width, height: status.height)
            
            let borderBottom = UIView()
            cell.addSubview(borderBottom)
            borderBottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
            borderBottom.backgroundColor = YMColors.PatientBorderDarkGray
            return cell
        }
        
        var prevCell: YMTouchableView?  = nil
        for cellData in data {
            prevCell = BuildCell(cellData, prev: prevCell)
        }
        
        YMLayout.SetViewHeightByLastSubview(ListPanel, lastSubView: prevCell!, bottomPadding: 20.LayoutVal())
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ListPanel)
    }
    
    func Reload() {
        YMLayout.ClearView(view: ListPanel)
        ResetAllTab()
        ListPanel.align(Align.UnderMatchingLeft, relativeTo: TabBarPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        FullPageLoading.Show()
        AppointmentList = nil
        RecordActions.AppointmentApi.YMGetAppointmentList()
    }
}






