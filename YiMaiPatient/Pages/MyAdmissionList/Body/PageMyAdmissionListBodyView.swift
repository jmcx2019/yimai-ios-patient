//
//  PageMyAdmissionListBodyView.swift
//  YiMai
//
//  Created by superxing on 16/11/23.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageMyAdmissionListBodyView: PageBodyView {
    var ListActions: PageMyAdmissionListActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        ListActions = PageMyAdmissionListActions(navController: self.NavController, target: self)
    }
    
    func DrawCell(data: [String: AnyObject], prev: YMTouchableView? = nil) -> YMTouchableView {
        let cell = YMLayout.GetTouchableView(useObject: ListActions, useMethod: "CellTouched:".Sel())
        BodyView.addSubview(cell)
        
        let readen = "\(data["read"]!)"
        let dividerLine = UIView()
        var btnTextColor = YMColors.PatientFontGreen
        
        if("0" == readen) {
            dividerLine.backgroundColor = YMColors.FontLighterGray
        } else {
            cell.backgroundColor = YMColors.MsgReadenBkg
            dividerLine.backgroundColor = YMColors.White
            btnTextColor = YMColors.FontGray
        }
        
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.frame = CGRect(x: 0, y: 0, width: 590.LayoutVal(), height: 0)
        infoLabel.text = "\(data["text"]!)"
        infoLabel.textColor = YMColors.FontGray
        infoLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        infoLabel.sizeToFit()
        
        if(infoLabel.width < 590.LayoutVal()) {
            infoLabel.frame = CGRect(x: 0, y: 0, width: 590.LayoutVal(), height: infoLabel.height)
        }
        
        let btn = UIView()
        let title = YMLayout.GetNomalLabel("点击查看", textColor: btnTextColor, fontSize: 24.LayoutVal())
        let time = YMLayout.GetNomalLabel("\(data["time"]!)", textColor: YMColors.FontLighterGray, fontSize: 24.LayoutVal())
        btn.addSubview(title)
        btn.addSubview(time)
        
        
        
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 60.LayoutVal(), width: 670.LayoutVal(), height: 0)
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 40.LayoutVal(), width: 670.LayoutVal(), height: 0)
        }
        
        cell.UserObjectData = data
        
        cell.addSubview(infoLabel)
        cell.addSubview(btn)
        cell.addSubview(dividerLine)
        
        infoLabel.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: infoLabel.width, height: infoLabel.height)
        dividerLine.anchorToEdge(Edge.Top, padding: 80.LayoutVal() + infoLabel.height, width: 670.LayoutVal(), height: YMSizes.OnPx)
        btn.align(Align.UnderMatchingLeft, relativeTo: dividerLine, padding: 0, width: 670.LayoutVal(), height: 60.LayoutVal())
        
        title.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: title.width, height: title.height)
        time.align(Align.ToTheRightCentered, relativeTo: title, padding: 40.LayoutVal(), width: time.width, height: time.height)
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10.LayoutVal()
        
        YMLayout.SetViewHeightByLastSubview(cell, lastSubView: btn)
        
        return cell
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        var prev: YMTouchableView? = nil
        
        YMLayout.ClearView(view: BodyView)
        BodyView.contentOffset = CGPoint(x: 0, y: -YMSizes.PageTopHeight)
        
        for cellData in data {
            prev = DrawCell(cellData, prev: prev)
        }

        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev, padding: 40.LayoutVal())
    }
}















