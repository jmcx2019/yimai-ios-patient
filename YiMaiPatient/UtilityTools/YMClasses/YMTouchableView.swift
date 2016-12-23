//
//  YMTouchableView.swift
//  YiMai
//
//  Created by why on 16/4/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Toucan
import Neon

typealias ScrollCellBtnTouched = ((String?, AnyObject?) -> Void)

class YMScrollCell: UIScrollView, UIScrollViewDelegate {
    var UserStringData: String = ""
    var UserObjectData: AnyObject? = nil
    
    private var ButtonArray = [UIView]()
    
    init() {
        super.init(frame: CGRect.zero)
        self.pagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func CellBtnTouched(gr: UIGestureRecognizer) {
        let btn = gr.view as? YMTouchableView
        let cb = btn?.UserAnyData as? ScrollCellBtnTouched
        cb?(self.UserStringData, self.UserObjectData)
    }
    
    func SetCellBtn(btnTitle: String, titleColor: UIColor, bkgColor: UIColor, fontSize: CGFloat,
                    padding: CGFloat = 40.LayoutVal(), callback: ScrollCellBtnTouched? = nil) {
        let titleLabel = YMLayout.GetNomalLabel(btnTitle, textColor: titleColor, fontSize: fontSize)
        let btn = YMLayout.GetTouchableView(useObject: self, useMethod: "CellBtnTouched:".Sel())
        btn.backgroundColor = bkgColor
        btn.UserAnyData = callback
        btn.addSubview(titleLabel)
        let btnWidth = titleLabel.width + padding * 2
        
        self.addSubview(btn)
        
        if(0 == ButtonArray.count) {
            btn.anchorToEdge(Edge.Right, padding: -btnWidth, width: btnWidth, height: self.height)
        } else {
            let lastBtn = ButtonArray.last
            btn.align(Align.ToTheRightCentered, relativeTo: lastBtn!, padding: 0, width: btnWidth, height: self.height)
        }
        
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
        
        YMLayout.SetHScrollViewContentSize(self, lastSubView: btn)
    }
}

public class YMTouchableView: UIView {
    public var UserStringData: String = ""
    public var UserObjectData: AnyObject? = nil
    public var UserAnyData: Any? = nil
}

public class YMTouchableImageView: UIImageView {
    public var UserStringData: String = ""
    public var UserObjectData: AnyObject? = nil
}


public class YMLabel: ActiveLabel {
    public var UserStringData: String = ""
    public var UserObjectData: AnyObject? = nil
    public var UserAnyData: Any? = nil
}








