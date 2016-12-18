//
//  PageWalletRecordBodyView.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/15.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageWalletRecordBodyView: PageBodyView {
    var ListActions: PageWalletRecordActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        ListActions = PageWalletRecordActions(navController: NavController!, target: self)
    }
    
    func DrawCell(data: [String: AnyObject], prev: UIView? = nil) -> UIView {
        let cell = UIView()
        cell.backgroundColor = YMColors.White
        
        let name = YMVar.GetStringByKey(data, key: "name")
        let time = YMVar.GetStringByKey(data, key: "time")
        let price = YMVar.GetStringByKey(data, key: "price")
        let transId = YMVar.GetStringByKey(data, key: "transaction_id")
        
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: YMColors.PatientFontGreen, fontSize: 30.LayoutVal())
        let timeLabel = YMLayout.GetNomalLabel(time, textColor: YMColors.PatientFontGray, fontSize: 24.LayoutVal())
        let priceLabel = YMLayout.GetNomalLabel("费用 \(price) ￥", textColor: YMColors.PatientFontGreen, fontSize: 24.LayoutVal())
        let transIdLabel = YMLayout.GetNomalLabel("单号 \(transId)", textColor: YMColors.PatientFontGray, fontSize: 24.LayoutVal())
        
        BodyView.addSubview(cell)
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 140.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 140.LayoutVal())
        }
        
        cell.addSubview(nameLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(priceLabel)
        cell.addSubview(transIdLabel)
        
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        timeLabel.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 20.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        priceLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 10.LayoutVal(), width: priceLabel.width, height: priceLabel.height)
        transIdLabel.align(Align.ToTheRightCentered, relativeTo: priceLabel, padding: 20.LayoutVal(), width: transIdLabel.width, height: transIdLabel.height)
        
        return cell
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: BodyView)
        if(0 == data.count){
            return
        }
        
        var cell: UIView? = nil
        for entry in data {
            cell = DrawCell(entry, prev: cell)
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: cell)
    }
}






