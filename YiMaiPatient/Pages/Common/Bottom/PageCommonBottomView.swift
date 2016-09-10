//
//  PageCommonBottomView.swift
//  YiMai
//
//  Created by why on 16/4/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageCommonBottomView : NSObject {
    public let BottomViewPanel : UIView = UIView(frame: YMSizes.NormalBottomSize)
    
    private var ParentView: UIView? = nil
    
    private var IndexButton: UIView? = nil
    private var YiMaiButton: UIView? = nil
    private var PersonalButton: UIView? = nil
    
    private var Actions: YMCommonActions? = nil
    
    private var IndexImageButton: YMTouchableImageView? = nil
    private var YiMaiImageButton: YMTouchableImageView? = nil
    private var PersonalImageButton: YMTouchableImageView? = nil
    
    public static var BottomButtonImage = [
        YMCommonStrings.CS_PAGE_INDEX_NAME:"IndexButtonHomeBlue"
    ]
    
    convenience init(parentView:UIView, navController:UINavigationController) {
        self.init()
        self.ParentView = parentView
        Actions = YMCommonActions(navController: navController)
        Actions!.JumpWidthAnimate = false
        self.ViewLayout(navController)
    }
    
    private func ViewLayout(navController:UINavigationController?){
        ParentView!.addSubview(BottomViewPanel)
        BottomViewPanel.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
        DrawBottomPanel()
    }
    
    private func DrawBottomPanel() {

    }
}