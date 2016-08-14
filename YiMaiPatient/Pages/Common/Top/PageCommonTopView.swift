//
//  PageCommonTopView.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageCommonTopView : NSObject {
    public let TopViewPanel : UIView = UIView()
    private var TopBackground = UIImageView()
    private var TopTitle = UILabel()
    private var TopGoBackBtn = UIImageView()
    
    private var ParentView:UIView? = nil
    private var TitleString = ""
    private var CommonActions : YMCommonActions? = nil

    convenience init(parentView:UIView, titleString:String, navController:UINavigationController? = nil) {
        self.init()
        self.ParentView = parentView
        self.TitleString = titleString
        
        self.ViewLayout(navController)
    }
    
    private func ViewLayout(navController:UINavigationController?){
        ParentView!.addSubview(TopViewPanel)
        TopViewPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: YMSizes.PageTopHeight)

        DrawBackgroundLayer()
        DrawTitle()
        
        if(nil != navController){
            self.SetGoBackButton(navController!)
        }
    }
    
    private func DrawBackgroundLayer() {
        TopBackground = YMLayout.GetSuitableImageView("PageTopBkg")
        TopViewPanel.addSubview(TopBackground)
        TopBackground.fillSuperview()
    }
    
    private func DrawTitle(){
        TopTitle.text = self.TitleString
        TopTitle.font = UIFont.systemFontOfSize(YMSizes.PageTopTitleFontSize)
        TopTitle.textColor = YMColors.PatientFontGray
        TopTitle.textAlignment = NSTextAlignment.Center
        
        TopViewPanel.addSubview(TopTitle)
        TopTitle.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 26.LayoutVal(), otherSize: YMSizes.PageTopTitleFontSize)
    }
    
    private func SetGoBackButton(navController:UINavigationController) {
        CommonActions = YMCommonActions(navController: navController)
        let backgroundPanel = YMLayout.GetTouchableView(useObject: CommonActions!, useMethod: "GoBack:".Sel())
        backgroundPanel.backgroundColor = YMColors.None 
        
        TopGoBackBtn = YMLayout.GetSuitableImageView("PageTopBackBtn")
        
        TopViewPanel.addSubview(backgroundPanel)
        backgroundPanel.anchorInCorner(Corner.TopLeft, xPad: 12.LayoutVal(), yPad: 45.LayoutVal(), width: 60.LayoutVal(), height: 60.LayoutVal())
        backgroundPanel.addSubview(TopGoBackBtn)
        TopGoBackBtn.anchorToEdge(Edge.Bottom, padding: 4.LayoutVal(), width: TopGoBackBtn.width, height: TopGoBackBtn.height)
    }
}







