//
//  PageSYSBroadcastBodyView.swift
//  YiMai
//
//  Created by superxing on 16/10/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import ChameleonFramework

class PageSYSBroadcastBodyView: PageBodyView {
    var BroadcastActions: PageSYSBroadcastActions!
    var CurrentPage = 1
    var PrevMsgView: UIView? = nil
    var NoMoreFlag = false
    
    override func ViewLayout() {
        super.ViewLayout()

        BroadcastActions = PageSYSBroadcastActions(navController: self.NavController!, target: self)
    }
    
    func GetList() {
        FullPageLoading.Show()
        BroadcastActions.BroadcastApi.YMGetAllRadio("\(CurrentPage)")
    }
    
    func BuildCell(data: [String: AnyObject], prev: UIView? = nil) -> YMTouchableView {
        let cell = YMLayout.GetTouchableView(useObject: BroadcastActions, useMethod: "ShowBroadcastDetail:".Sel())
        
        BodyView.addSubview(cell)
        if(nil != prev) {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 30.LayoutVal(),
                       width: YMSizes.PageWidth, height: 400.LayoutVal())
        } else {
            cell.anchorAndFillEdge(Edge.Top, xPad: 0.LayoutVal(), yPad: 30.LayoutVal(), otherSize: 400.LayoutVal())
        }
        
//        author = 123;
//        id = 1;
//        "img_url" = "/uploads/article/1.png";
//        name = test;
//        time = "2016-05-03 15:02:37";
//        unread = "<null>";
//        url = "/article/1";
        
        let timeString = YMVar.GetStringByKey(data, key: "time")
        let ymdTime = timeString.componentsSeparatedByString(" ")[0]
        let titleStr = YMVar.GetStringByKey(data, key: "name", defStr: "文章")
        let url = YMVar.GetStringByKey(data, key: "img_url")    
        
        let cover = YMLayout.GetSuitableImageView("SysBroadcastCover700x400")
        let titleLabel = YMLayout.GetNomalLabel(titleStr, textColor: YMColors.White, fontSize: 26.LayoutVal())
        let timeLabel = YMLayout.GetNomalLabel(ymdTime, textColor: YMColors.White, fontSize: 26.LayoutVal())
        
        let textPanel = UIView()
        textPanel.backgroundColor = HexColor("#000000", 0.4)
        
        cell.addSubview(cover)
        cell.addSubview(textPanel)
        
        cover.fillSuperview()
        textPanel.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 70.LayoutVal())

        textPanel.addSubview(titleLabel)
        textPanel.addSubview(timeLabel)
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 500.LayoutVal(), height: titleLabel.height)
        titleLabel.sizeToFit()
        
        titleLabel.anchorToEdge(Edge.Left, padding: 20.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        timeLabel.anchorToEdge(Edge.Right, padding: 20.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        
        YMLayout.LoadImageFromServer(cover, url: url)
        
        cell.UserObjectData = data

        return cell
    }
    
    func AddMsg(data: [[String: AnyObject]]) {
        for entryData in data {
            PrevMsgView = BuildCell(entryData, prev: PrevMsgView)
        }
        
        if(nil != PrevMsgView) {
            YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: PrevMsgView!)
        }
        
        if(data.count > 0) {
            CurrentPage += 1
        } else {
            NoMoreFlag = true
        }
    }
}









