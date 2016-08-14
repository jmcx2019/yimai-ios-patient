//
//  PageIndexBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageIndexBodyView: PageBodyView {
    override func ViewLayout() {
        super.ViewLayout()
        DrawBkg()
    }
    
    func DrawBkg() {
        let img = YMLayout.GetSuitableImageView("TIndexBkg")
        BodyView.addSubview(img)
        
        img.fillSuperview()
    }
}