//
//  PageAboutYiMaiBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAboutYiMaiBodyView: PageBodyView {
    private var AboutActions: PageAboutYiMaiActions? = nil
    private let Banner = YMLayout.GetSuitableImageView("YMPlatformAboutBanner")
    
    override func ViewLayout() {
        super.ViewLayout()
        AboutActions = PageAboutYiMaiActions(navController: self.NavController!, target: self)
        
        DrawBanner()
        DrawButtons()
    }
    
    private func DrawBanner() {
        BodyView.addSubview(Banner)
        Banner.anchorToEdge(Edge.Top, padding: 0, width: Banner.width, height: Banner.height)
    }
    
    private func DrawButtons() {
        let intro = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: AboutActions!, useMethod: "ShowIntro:".Sel(),
            label: UILabel(), text: "简介")
        
        let contact = YMLayout.GetCommonFullWidthTouchableView(
            BodyView, useObject: AboutActions!, useMethod: "ShowContact:".Sel(),
            label: UILabel(), text: "联系我们")
        
        BodyView.addSubview(intro)
        BodyView.addSubview(contact)
        
        intro.align(Align.UnderMatchingLeft, relativeTo: Banner, padding: 0,
                    width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        contact.align(Align.UnderMatchingLeft, relativeTo: intro, padding: 0,
                    width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: contact)
    }
}


























