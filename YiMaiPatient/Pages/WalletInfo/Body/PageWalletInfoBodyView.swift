//
//  PageWalletInfoBodyView.swift
//  YiMaiPatient
//
//  Created by old-king on 16/11/15.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageWalletInfoBodyView: PageBodyView {
    var InfoActions: PageWalletInfoActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        InfoActions = PageWalletInfoActions(navController: self.NavController!, target: self)
    }
    
    func DrawFullBody() {
        YMLayout.ClearView(view: BodyView)
        let bkg = YMLayout.GetSuitableImageView("YiMaiPatientWalletBkg")
        let payBtn = YMLayout.GetTouchableView(useObject: InfoActions, useMethod: "ShowError:".Sel())
        let outBtn = YMLayout.GetTouchableView(useObject: InfoActions, useMethod: "ShowError:".Sel())
        
        payBtn.backgroundColor = YMColors.None
        outBtn.backgroundColor = YMColors.None
        
        BodyView.addSubview(bkg)
        BodyView.addSubview(payBtn)
        BodyView.addSubview(outBtn)
        
        bkg.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: bkg.height)
        payBtn.anchorToEdge(Edge.Top, padding: 825.LayoutVal(), width: 670.LayoutVal(), height: 80.LayoutVal())
        outBtn.align(Align.UnderMatchingLeft, relativeTo: payBtn, padding: 20.LayoutVal(),
                     width: 670.LayoutVal(), height: 80.LayoutVal())
    }
}




