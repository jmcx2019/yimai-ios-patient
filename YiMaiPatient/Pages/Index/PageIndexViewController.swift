//
//  PageIndexViewController.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit
import Neon

public class PageIndexViewController: PageViewController {
    public var BodyView: PageIndexBodyView? = nil
    override func PageLayout() {
        super.PageLayout()
        let img = YMLayout.GetSuitableImageView("TIndexBkg")
        let scroll = UIScrollView()

        self.SelfView!.addSubview(scroll)
        scroll.fillSuperview()
        scroll.addSubview(img)
        
        img.anchorToEdge(Edge.Top, padding: 0, width: img.width, height: img.height)
        
        YMLayout.SetVScrollViewContentSize(scroll, lastSubView: img)
        
//        BodyView = PageIndexBodyView(parentView: self.SelfView!, navController: self.NavController!)
    }
}
