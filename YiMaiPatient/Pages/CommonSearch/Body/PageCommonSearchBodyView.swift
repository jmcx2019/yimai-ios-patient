//
//  PageCommonSearchBodyView.swift
//  YiMai
//
//  Created by why on 16/6/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageCommonSearchBodyView: PageBodyView {
    private var ResultList: YMTableView? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        
        BuildTable()
    }
    
    private func CellBuilder(cell: YMTableViewCell, data: AnyObject?) -> Void {
        let realData = data as! [String: AnyObject]
        let cellInner = UILabel()
        cellInner.backgroundColor = YMColors.PatientFontGreen
        cellInner.font = YMFonts.YMDefaultFont(20.LayoutVal())
        cellInner.text = realData["idx"] as? String
        cellInner.textColor = YMColors.White
        cellInner.sizeToFit()
        
        cell.frame = CGRectMake(0,0, YMSizes.PageWidth, 40.LayoutVal())
        cell.CellTitleHeight = 40.LayoutVal()
        cell.CellFullHeight = 40.LayoutVal()
        cell.addSubview(cellInner)
        cell.CellData = data
        
        cellInner.fillSuperview()
        
        if(nil != realData["sub"]) {
            cell.SubCell = realData["sub"]!
        }
        
        let bottom = UIView()
        bottom.backgroundColor = YMColors.DividerLineGray
        cell.addSubview(bottom)
        bottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 1)
        
        cell.CellInnerView = cellInner
    }

    private func SubCellLayout(cell: YMTableViewCell) {
        if(nil == cell.SubCell) {return}

        let subTable = cell.SubCell! as! YMTableView

        cell.addSubview(subTable.TableViewPanel)
        let subTableView = subTable.TableViewPanel

        let tableHeight = subTable.GetTableFullHeight()
        subTableView.anchorToEdge(Edge.Top, padding: cell.CellTitleHeight, width: YMSizes.PageWidth, height: tableHeight)
        subTable.DrawTableView(false)

        cell.CellFullHeight = subTableView.height + cell.CellTitleHeight
    }
    
    private func SubCellBuilder(cell: YMTableViewCell, data: AnyObject?) -> Void {
        let realData = data as! [String: AnyObject]
        let cellInner = UILabel()
        cellInner.backgroundColor = YMColors.White
        cellInner.font = YMFonts.YMDefaultFont(16.LayoutVal())
        cellInner.text = realData["idx"] as? String
        cellInner.textColor = YMColors.FontGray
        cellInner.textAlignment = NSTextAlignment.Center
        cellInner.sizeToFit()
        
        cell.frame = CGRectMake(0,0, YMSizes.PageWidth, 40.LayoutVal())
        cell.CellTitleHeight = 40.LayoutVal()
        cell.CellFullHeight = 40.LayoutVal()
        cell.addSubview(cellInner)
        
        let bottom = UIView()
        bottom.backgroundColor = YMColors.DividerLineGray
        cell.addSubview(bottom)
        bottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 1)
        
        cellInner.fillSuperview()
        cell.CellInnerView = cellInner
    }
    
    private func CellTouched(cell: YMTableViewCell) -> Void {
    }
    
    private func SubCellTouched(cell: YMTableViewCell) -> Void {
    }
    
    private func BuildTable() {
        ResultList?.TableViewPanel.removeFromSuperview()
        ResultList = YMTableView(builer: CellBuilder, subBuilder: SubCellLayout, touched: CellTouched)
        
        let content = [
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c","d"],
            ["a","b","c","d"],
            ["a","b","c","d"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c","d"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            ["a","b","c"],
            []
        ]
        
        var i = 0
        for v in content {
            var subTable:YMTableView? = nil
            var data = [String: AnyObject]()

            if(0 != v.count){
                subTable = YMTableView(builer: SubCellBuilder, subBuilder: nil, touched: SubCellTouched)
                
                for sv in v {

                    var subData = [String: AnyObject]()
                    subData["data"] = sv
                    subData["idx"] = "index: \(sv)"
                    subTable!.AppendCell(subData)
                }
                
                data["sub"] = subTable!
            }
            
            data["data"] = v
            data["idx"] = "index: \(i)"
            i = i + 1

            ResultList?.AppendCell(data)
        }
        
        BodyView.addSubview(ResultList!.TableViewPanel)
        ResultList?.TableViewPanel.fillSuperview()
        ResultList?.DrawTableView(false)
        ResultList?.SubCellLayout()
    }
}








