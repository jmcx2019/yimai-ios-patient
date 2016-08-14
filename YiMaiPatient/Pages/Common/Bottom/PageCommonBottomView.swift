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
        YMCommonStrings.CS_PAGE_INDEX_NAME:"IndexButtonHomeBlue",
        YMCommonStrings.CS_PAGE_YIMAI_NAME:"IndexButtonYiMaiGray",
        YMCommonStrings.CS_PAGE_PERSONAL_NAME:"IndexButtonPersonalGray"
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
        IndexButton = UIView()
        YiMaiButton = UIView()
        PersonalButton = UIView()
        
        let bottomShadow = UIView()
        bottomShadow.layer.shadowOffset = CGSizeMake(0, 4);
        bottomShadow.layer.shadowOpacity = 0.6;
        bottomShadow.layer.shadowColor = UIColor.blackColor().CGColor
        bottomShadow.backgroundColor = UIColor.whiteColor()
        
        BottomViewPanel.addSubview(bottomShadow)
        BottomViewPanel.addSubview(IndexButton!)
        BottomViewPanel.addSubview(YiMaiButton!)
        BottomViewPanel.addSubview(PersonalButton!)
        
        bottomShadow.fillSuperview()
        BottomViewPanel.groupAndFill(group: Group.Horizontal, views: [IndexButton!, YiMaiButton!, PersonalButton!], padding: 0)

        IndexImageButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "PageJumpToByImageViewSender:".Sel(),
            imageName: PageCommonBottomView.BottomButtonImage[YMCommonStrings.CS_PAGE_INDEX_NAME]!)
        
        YiMaiImageButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "PageJumpToByImageViewSender:".Sel(),
            imageName: PageCommonBottomView.BottomButtonImage[YMCommonStrings.CS_PAGE_YIMAI_NAME]!)
        
        PersonalImageButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "PageJumpToByImageViewSender:".Sel(),
            imageName: PageCommonBottomView.BottomButtonImage[YMCommonStrings.CS_PAGE_PERSONAL_NAME]!)
        
        IndexImageButton?.UserStringData = YMCommonStrings.CS_PAGE_INDEX_NAME
        YiMaiImageButton?.UserStringData = YMCommonStrings.CS_PAGE_YIMAI_NAME
        PersonalImageButton?.UserStringData = YMCommonStrings.CS_PAGE_PERSONAL_NAME
        
        IndexButton?.addSubview(IndexImageButton!)
        YiMaiButton?.addSubview(YiMaiImageButton!)
        PersonalButton?.addSubview(PersonalImageButton!)
        
        IndexImageButton?.anchorInCenter(width: (IndexImageButton?.width)!, height: (IndexImageButton?.height)!)
        YiMaiImageButton?.anchorInCenter(width: (YiMaiImageButton?.width)!, height: (YiMaiImageButton?.height)!)
        PersonalImageButton?.anchorInCenter(width: (PersonalImageButton?.width)!, height: (PersonalImageButton?.height)!)
    }
}