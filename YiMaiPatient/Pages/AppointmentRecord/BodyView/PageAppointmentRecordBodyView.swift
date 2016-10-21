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
    
    var ListPanel = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        RecordActions = PageAppointmentRecordActions(navController: self.NavController, target: self)
        DrawFullBody()
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
    
    func DrawList(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: ListPanel)
        ListPanel.align(Align.UnderMatchingLeft, relativeTo: TabBarPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        
        func BuildCell(data: [String: AnyObject], prev: YMTouchableView?) -> YMTouchableView {
            let cell = YMLayout.GetTouchableView(useObject: RecordActions, useMethod: "CellTouched:".Sel())
            
            ListPanel.addSubview(cell)
            if(nil == prev) {
                cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
            } else {
                cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
            }
            
            //TODO: 画cell
            
            return cell
        }
        
        var prevCell: YMTouchableView?  = nil
        for cellData in data {
            prevCell = BuildCell(cellData, prev: prevCell)
        }
    }
}






