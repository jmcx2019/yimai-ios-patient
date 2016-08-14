//
//  YMTableView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/11.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public typealias YMTableViewCellTouched = ((YMTableViewCell) -> Void)
public typealias YMTableViewCellBuilder = ((YMTableViewCell, AnyObject?) -> Void)
public typealias YMTableViewSubCellBuilder = ((YMTableViewCell) -> Void)

public class YMTableViewCell: UIView {
    private var Prev: YMTableViewCell? = nil
    private var Next: YMTableViewCell? = nil
    private var ParentTableView: YMTableView?

    public var CellData: AnyObject? = nil
    public var CellInnerView: UIView? = nil
    
    public var SubCell: AnyObject? = nil

    public var Expanded: Bool = false
    
    public var CellTitleHeight: CGFloat = 0
    public var CellFullHeight: CGFloat = 0
}

public class YMTableViewDelegate: NSObject {
    public func CellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view as! YMTableViewCell
        let table = cell.ParentTableView!
        
        table.CellTouched?(cell)
        table.CellExpandStateToggle(cell)
    }
}

public class YMTableView: NSObject {
    let CellList = YMTableViewCell()

    let CellActions = YMTableViewDelegate()
    
    public var CellBuilder: YMTableViewCellBuilder? = nil
    public var CellTouched: YMTableViewCellTouched? = nil
    public var SubCellBuilder: YMTableViewSubCellBuilder? = nil
    
    public var TableViewPanel = UIScrollView()
    
    public var OnAnimate: Bool = false
    public var AnimatedCell: YMTableViewCell? = nil
    
    var LastCell: YMTableViewCell? = nil
    let ExpandAnimateLock = NSObject()
    
    init(builer: YMTableViewCellBuilder,
        subBuilder: YMTableViewSubCellBuilder?,
        touched: YMTableViewCellTouched?) {
            super.init()
            self.CellBuilder = builer
            self.CellTouched = touched
            self.SubCellBuilder = subBuilder
            LastCell = CellList
        
            self.TableViewPanel.backgroundColor = YMColors.White
    }
    
    private func GetTouchableView() -> YMTableViewCell {
        let newView = YMTableViewCell()

        let tapGR = UITapGestureRecognizer(target: CellActions, action: "CellTouched:".Sel())
        
        newView.userInteractionEnabled = true
        newView.addGestureRecognizer(tapGR)
        
        return newView
    }
    
    public func GetCellCount() -> Int {
        var cellPointer = self.CellList.Next
        var count = 0
        
        while(nil != cellPointer) {
            count += 1
            cellPointer = cellPointer!.Next
        }
        
        return count
    }
    
    public func AppendCell(data: AnyObject) ->  YMTableView {
        let cell = GetTouchableView()
        
        cell.ParentTableView = self
        cell.Prev = LastCell
        
        cell.layer.masksToBounds = true

        LastCell?.Next = cell
        LastCell = cell

        self.CellBuilder!(cell, data)

        return self
    }
    
    public func GetTableFullHeight() -> CGFloat {
        var tableHeight:CGFloat = 0
        var cellPointer = self.CellList.Next
        
        while(nil != cellPointer) {
            tableHeight += cellPointer!.CellTitleHeight
            cellPointer = cellPointer!.Next
        }
        
        return tableHeight
    }
    
    public func DrawTableView(setFullHeight: Bool = true) ->  YMTableView {
        if(nil == LastCell) {return self}
        var cellPointer = CellList.Next
        if(nil != cellPointer) {
            TableViewPanel.addSubview(cellPointer!)
            cellPointer?.anchorToEdge(Edge.Top, padding: 0, width: cellPointer!.width, height: cellPointer!.height)

            var nextPointer = cellPointer?.Next
            while(nil != nextPointer) {
                TableViewPanel.addSubview(nextPointer!)
                nextPointer?.align(Align.UnderMatchingLeft, relativeTo: cellPointer!,
                    padding: 0, width: nextPointer!.width, height: nextPointer!.height)
                
                cellPointer = nextPointer
                nextPointer = nextPointer?.Next
            }
        }
        

        TableViewPanel.contentSize = CGSizeMake(
            LastCell!.width,
            LastCell!.frame.origin.y + LastCell!.height
        )
        if(setFullHeight) {
            TableViewPanel.frame = CGRect(x: 0,y: 0,width: LastCell!.width,height: LastCell!.frame.origin.y + LastCell!.height)
        }

        return self
    }

    public func CellExpandStateToggle(cell: YMTableViewCell) {
        objc_sync_enter(self.ExpandAnimateLock)

        if(OnAnimate){return}
        OnAnimate = true
        if(nil != cell.SubCell){
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            if(cell.Expanded) {
                CellCollapse(cell)
            } else {
                CellExpand(cell)
            }

            AnimatedCell = cell
            UIView.setAnimationDelegate(self)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
            UIView.commitAnimations()
        }
    }

    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        OnAnimate = false
        if(nil != AnimatedCell) {
            AnimatedCell!.Expanded = !AnimatedCell!.Expanded
        }
        
        objc_sync_exit(self.ExpandAnimateLock)
    }
    
    private func CellCollapse(cell: YMTableViewCell) {
        var cellOffSet: CGFloat = 0
        var cellPointer = self.CellList.Next

        while(nil != cellPointer) {
            
            cellPointer?.Expanded = false
            cellPointer?.frame = CGRectMake(0, cellOffSet, cellPointer!.width, cellPointer!.CellTitleHeight)
            cellOffSet = cellOffSet + cellPointer!.CellTitleHeight
            
            cellPointer = cellPointer?.Next
        }
    }
    
    private func CellExpand(cell: YMTableViewCell) {
        var cellOffSet: CGFloat = 0
        var cellPointer = self.CellList.Next
        
        while(nil != cellPointer) {
            cellPointer?.Expanded = false

            if(cell != cellPointer) {
                cellPointer?.frame = CGRectMake(0, cellOffSet, cellPointer!.width, cellPointer!.CellTitleHeight)
                cellOffSet = cellOffSet + cellPointer!.CellTitleHeight
            } else {
                cellPointer?.frame = CGRectMake(0, cellOffSet, cellPointer!.width, cellPointer!.CellFullHeight)
                cellOffSet = cellOffSet + cellPointer!.CellFullHeight
            }
            
            cellPointer = cellPointer?.Next
        }
    }
    
    public func SubCellLayout() {
        var cellPointer = self.CellList.Next
        
        while(nil != cellPointer) {
            self.SubCellBuilder?(cellPointer!)
            cellPointer = cellPointer?.Next
        }
    }
    
    public func Clear() {
        var cellPointer: YMTableViewCell? = nil

        while(nil != LastCell) {
            if(self.CellList == LastCell) {
                LastCell?.Next = nil
                break
            }
            
            cellPointer = LastCell
            LastCell = cellPointer?.Prev
            
            let subTable = cellPointer?.SubCell as? YMTableView
            subTable?.Clear()

            cellPointer?.removeFromSuperview()
            cellPointer?.Prev = nil
            cellPointer?.Next = nil
            cellPointer?.CellData = nil
            cellPointer?.CellInnerView = nil
            cellPointer?.SubCell = nil
            cellPointer?.ParentTableView = nil
            cellPointer = nil
        }
    }
}



















