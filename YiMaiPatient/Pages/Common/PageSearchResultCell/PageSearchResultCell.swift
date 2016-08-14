//
//  PageSameXCell.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public typealias ResultCellLayout = ((UIView, UIView?, UIView) -> Void)

public class PageSearchResultCell {
    public static func LayoutACell(parent: UIView,
                               info: [String: AnyObject],
                               prev: UIView?,
                               act: AnyObject,
                               sel: Selector,
                               layoutCallback: ResultCellLayout? = nil) -> YMTouchableView {

        
        let cell = YMLayout.GetTouchableView(useObject: act, useMethod: sel)
        cell.backgroundColor = YMColors.PanelBackgroundGray
        cell.UserObjectData = info

        if(nil != layoutCallback) {
            layoutCallback!(parent, prev, cell)
        } else {
            parent.addSubview(cell)
            if(nil == prev) {
                cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
            } else {
                cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0,
                           width: YMSizes.PageWidth, height: 150.LayoutVal())
            }
        }
        
        let headimage = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let name = UILabel()
        let jobTitle = UILabel()
        let dept = UILabel()
        let hospital = UILabel()
        let relation = UILabel()
        let bottomBorder = UIView()
        let divider = UIView()
        
        
        cell.addSubview(headimage)
        cell.addSubview(name)
        cell.addSubview(jobTitle)
        cell.addSubview(dept)
        cell.addSubview(hospital)
        cell.addSubview(bottomBorder)
        cell.addSubview(divider)
        
        bottomBorder.backgroundColor = YMColors.DividerLineGray
        bottomBorder.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        headimage.anchorInCorner(Corner.TopLeft,
                                 xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
                                 width: headimage.width, height: headimage.height)
        
        name.text = "\(info["name"]!)"
        name.font = YMFonts.YMDefaultFont(30.LayoutVal())
        name.textColor = YMColors.FontGray
        name.sizeToFit()
        name.anchorInCorner(Corner.TopLeft,
                            xPad: 180.LayoutVal(), yPad: 30.LayoutVal(),
                            width: name.width, height: name.height)
        
        let jobTitleString = info["job_title"] as? String
        if(nil != jobTitleString) {
            jobTitle.text = jobTitleString!
            jobTitle.textColor = YMColors.FontGray
            jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
            jobTitle.sizeToFit()
            
            divider.backgroundColor = YMColors.FontBlue
            divider.align(Align.ToTheRightCentered, relativeTo: name,
                          padding: 14.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
            
            jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
                           padding: 14.LayoutVal(), width: jobTitle.width, height: jobTitle.height)
        }
        
        let deptInfo = info["department"] as? [String: AnyObject]
        if(nil != deptInfo) {
            dept.text = deptInfo!["name"] as? String
            dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
            dept.textColor = YMColors.FontGray
            dept.sizeToFit()
            
            dept.align(Align.UnderMatchingLeft,
                       relativeTo: name, padding: 8.LayoutVal(),
                       width: dept.width, height: dept.height)
        } else {
            let deptInfo = info["department"] as? String
            
            dept.text = deptInfo
            dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
            dept.textColor = YMColors.FontGray
            dept.sizeToFit()
            
            dept.align(Align.UnderMatchingLeft,
                       relativeTo: name, padding: 8.LayoutVal(),
                       width: dept.width, height: dept.height)
        }
        
        
        let hospitalInfo = info["hospital"] as? [String: AnyObject]
        if(nil != hospitalInfo) {
            hospital.text = hospitalInfo!["name"] as? String
            hospital.font = YMFonts.YMDefaultFont(24.LayoutVal())
            hospital.textColor = YMColors.FontLightGray
            hospital.sizeToFit()
            
            hospital.align(Align.UnderMatchingLeft,
                       relativeTo: name, padding: 40.LayoutVal(),
                       width: hospital.width, height: hospital.height)
        } else {
            let hospitalInfo = info["hospital"] as? String
            hospital.text = hospitalInfo
            hospital.font = YMFonts.YMDefaultFont(24.LayoutVal())
            hospital.textColor = YMColors.FontLightGray
            hospital.sizeToFit()
            
            hospital.align(Align.UnderMatchingLeft,
                           relativeTo: name, padding: 40.LayoutVal(),
                           width: hospital.width, height: hospital.height)
        }
        
        let relationDepth = info["relation"] as? Int

        if(nil != relationDepth) {
            var relationMap = ["1": "一度人脉", "2": "二度人脉"]
            var relationText = relationMap["\(relationDepth!)"]
            
            if(nil != relationText) {
                cell.addSubview(relation)
                relation.text = relationText!
                relation.textColor = YMColors.FontBlue
                relation.textAlignment = NSTextAlignment.Center
                relation.font = YMFonts.YMDefaultFont(20.LayoutVal())
                
                relation.layer.borderWidth = YMSizes.OnPx
                relation.layer.borderColor = YMColors.FontBlue.CGColor
                relation.layer.cornerRadius = 8.LayoutVal()
                relation.layer.masksToBounds = true
                
                relation.anchorInCorner(Corner.TopRight, xPad: 28.LayoutVal(), yPad: 30.LayoutVal(),
                                        width: 100.LayoutVal(), height: 30.LayoutVal())
            }
            
            relationMap.removeAll()
            relationText = nil
        }

        return cell
    }
    
    public static func GetCityTablView(provinces: [[String: AnyObject]],
                                       citys: [String: [ [String:AnyObject] ] ],
                                       parent: UIView,
                                       cityTouched: YMTableViewCellTouched) -> YMTableView {
        
       func ProvinceCellBuilder(cell: YMTableViewCell, data: AnyObject?) {
            let realData = data as! [String: AnyObject]
            let provData = realData["prov"] as! [String: AnyObject]
            let cellInner = UILabel()
            cellInner.font = YMFonts.YMDefaultFont(28.LayoutVal())
            cellInner.text = provData["name"] as? String
            cellInner.textColor = YMColors.FontGray
            cellInner.sizeToFit()
            
            cell.frame = CGRectMake(0,0, YMSizes.PageWidth, 80.LayoutVal())
            cell.CellTitleHeight = 80.LayoutVal()
            cell.CellFullHeight = 80.LayoutVal()
            cell.CellData = data
            cell.backgroundColor = YMColors.SearchCellBkg
            
            cell.addSubview(cellInner)
            cellInner.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                                   width: cellInner.width, height: cellInner.height)
            
            if(nil != realData["citys"]) {
                cell.SubCell = realData["citys"]!
            }
            
            let bottom = UIView()
            bottom.backgroundColor = YMColors.SearchCellBorder
            cell.addSubview(bottom)
            bottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            cell.CellInnerView = cellInner
        }
        
        func CityPanelBuilder(cell: YMTableViewCell) {
            if(nil == cell.SubCell) {return}
            
            let subTable = cell.SubCell! as! YMTableView
            
            cell.addSubview(subTable.TableViewPanel)
            let subTableView = subTable.TableViewPanel
            
            let tableHeight = subTable.GetTableFullHeight()
            subTableView.anchorToEdge(Edge.Top, padding: cell.CellTitleHeight, width: YMSizes.PageWidth, height: tableHeight)
            subTable.DrawTableView(false)
            
            cell.CellFullHeight = subTableView.height + cell.CellTitleHeight
        }
        
        func CityCellBuilder(cell: YMTableViewCell, data: AnyObject?) {
            let realData = data as! [String: AnyObject]
            let cellInner = UILabel()
            cellInner.font = YMFonts.YMDefaultFont(22.LayoutVal())
            cellInner.text = realData["name"] as? String
            cellInner.textColor = YMColors.FontGray
            cellInner.sizeToFit()
            
            cell.frame = CGRectMake(0,0, YMSizes.PageWidth, 60.LayoutVal())
            cell.CellTitleHeight = 60.LayoutVal()
            cell.CellFullHeight = 60.LayoutVal()
            cell.CellData = realData
            cell.backgroundColor = YMColors.SearchSubCellBkg
            
            cell.addSubview(cellInner)
            cellInner.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: cellInner.width, height: cellInner.height)
            
            let bottom = UIView()
            bottom.backgroundColor = YMColors.SearchSubCellBorder
            cell.addSubview(bottom)
            bottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)

            cell.CellInnerView = cellInner
        }

        
        let table = YMTableView(builer: ProvinceCellBuilder, subBuilder: CityPanelBuilder, touched: nil)
        
        for v in provinces {
            let cityTable = YMTableView(builer: CityCellBuilder, subBuilder: nil, touched: cityTouched)
            let provId = "\(v["id"]!)"
            let cityList = citys[provId]
            var provCellData = [String: AnyObject]()

            if(nil == cityList) {
                continue
            }
            if(0 != cityList!.count) {
                for v in cityList! {
                    cityTable.AppendCell(v)
                }
                provCellData["citys"] = cityTable
                provCellData["prov"] = v
                table.AppendCell(provCellData)
            }
        }
        
        parent.addSubview(table.TableViewPanel)
        table.TableViewPanel.fillSuperview()
        table.DrawTableView(false)
        table.SubCellLayout()
        
        return table
    }
    
    public static func GetHospitalSearchView(hospitals: [String: [ String: [ [String: AnyObject] ] ] ],
                                             parent: UIView,
                                             hospitalTouched: YMTableViewCellTouched) -> YMTableView {
        
        func HospitalCellBuilder(cell: YMTableViewCell, data: AnyObject?) {
            let realData = data as! [String: AnyObject]
            let cellInner = UILabel()
            cellInner.font = YMFonts.YMDefaultFont(28.LayoutVal())
            cellInner.text = realData["name"] as? String
            cellInner.textColor = YMColors.FontGray
            cellInner.sizeToFit()
            
            cell.frame = CGRectMake(0,0, YMSizes.PageWidth, 80.LayoutVal())
            cell.CellTitleHeight = 80.LayoutVal()
            cell.CellFullHeight = 80.LayoutVal()
            cell.CellData = realData
            cell.backgroundColor = YMColors.SearchCellBkg
            
            cell.addSubview(cellInner)
            cellInner.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                                   width: cellInner.width, height: cellInner.height)
  
            
            let bottom = UIView()
            bottom.backgroundColor = YMColors.SearchCellBorder
            cell.addSubview(bottom)
            bottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            cell.CellInnerView = cellInner
        }
        
        let table = YMTableView(builer: HospitalCellBuilder, subBuilder: nil, touched: hospitalTouched)
        
        for (_, vProv) in hospitals {
            for (_, vCity) in vProv {
                for vHos in vCity {
                    table.AppendCell(vHos)
                }
            }
        }

        parent.addSubview(table.TableViewPanel)
        table.TableViewPanel.fillSuperview()
        table.DrawTableView(false)
        
        return table
    }
    
    public static func GetDeptSearchView(dept: [[String: AnyObject]],
                                             parent: UIView,
                                             hospitalTouched: YMTableViewCellTouched) {
        
        func DeptCellBuilder(cell: YMTableViewCell, data: AnyObject?) {
            let realData = data as! [String: AnyObject]
            let cellInner = UILabel()
            cellInner.font = YMFonts.YMDefaultFont(28.LayoutVal())
            cellInner.text = realData["name"] as? String
            cellInner.textColor = YMColors.FontGray
            cellInner.sizeToFit()
            
            cell.frame = CGRectMake(0,0, YMSizes.PageWidth, 80.LayoutVal())
            cell.CellTitleHeight = 80.LayoutVal()
            cell.CellFullHeight = 80.LayoutVal()
            cell.CellData = realData
            cell.backgroundColor = YMColors.SearchCellBkg
            
            cell.addSubview(cellInner)
            cellInner.anchorToEdge(Edge.Left, padding: 40.LayoutVal(),
                                   width: cellInner.width, height: cellInner.height)
            
            
            let bottom = UIView()
            bottom.backgroundColor = YMColors.SearchCellBorder
            cell.addSubview(bottom)
            bottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            cell.CellInnerView = cellInner
        }
        
        let table = YMTableView(builer: DeptCellBuilder, subBuilder: nil, touched: hospitalTouched)

        for v in dept {
            table.AppendCell(v)
        }
        
        parent.addSubview(table.TableViewPanel)
        table.TableViewPanel.fillSuperview()
        table.DrawTableView(false)
    }
}




























