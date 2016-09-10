//
//  PageGetMyDoctorsBodyView.swift
//  YiMaiPatient
//
//  Created by superxing on 16/9/9.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageGetMyDoctorsBodyView: PageBodyView {
    var DoctorsActions: PageGetMyDoctorsActions? = nil
    var LoadingView: YMPageLoadingView? = nil
    
    let SearchPanel = UIView()
    
    override public func ViewLayout() {
        super.ViewLayout()
        
        BodyView.backgroundColor = YMColors.White
        DoctorsActions = PageGetMyDoctorsActions(navController: self.NavController!, target: self)
        DrawSearchPanel()
        
        LoadingView = YMPageLoadingView(parentView: self.BodyView)
        LoadingView?.Show()
    }
    
    func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.backgroundColor = YMColors.BackgroundGray
        
        let searchInput = YMTextField(aDelegate: nil)
        searchInput.EditEndCallback = DoctorsActions?.SearchInputEnded
        searchInput.MaxCharCount = 20
        
        let searchIconPadding = UIView(frame: CGRect(x: 0, y: 0, width: 60.LayoutVal(), height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("PageGetMyDoctorsSearchIcon")
        searchIconPadding.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        
        searchInput.SetLeftPadding(searchIconPadding)
        searchInput.placeholder = "搜索"
        searchInput.textColor = YMColors.PatientFontGreen
        
        SearchPanel.addSubview(searchInput)
        searchInput.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        
        searchInput.backgroundColor = YMColors.White
        searchInput.layer.cornerRadius = 10.LayoutVal()
        searchInput.layer.masksToBounds = true
    }
}