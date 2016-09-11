//
//  PageSearchDefaultBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/9/11.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon
import Kingfisher
import ChameleonFramework

class PageSearchDefaultBodyView: PageBodyView {
    var SearchActions: PageSearchDefaultActions? = nil
    
    let SearchPanel = UIView()
    let SearchInput = YMTextField(aDelegate: nil)
    let TabPanel = UIView()
    let DocPanel = UIView()
    
    var BoxPanel = UIView()
    var BoxMask: YMTouchableView? = nil
    let BoxInner = UIView()
    let BoxInfoPanel = UIView()
    
    let ByDocPanel = UIView()
    let ByHosPanel = UIView()
    let ByTagPanel = UIView()
    
    var SelectedDoc: [String: AnyObject]? = nil
    
    var LoadingView: YMPageLoadingView? = nil
    
    var CurrentFilter = [String: String!]()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SearchActions = PageSearchDefaultActions(navController: self.NavController!, target: self)
        Actions = SearchActions
        
        ParentView?.backgroundColor = HexColor("#f0f0f0")
        BodyView.backgroundColor = HexColor("#f0f0f0")
        
        DrawSearchPanel()
//        DrawTabPanel()
        DrawDoctorPanel()
        
        DrawByDocPanel()
        DrawByHosPanel()
        DrawByTagPanel()
        
        DrawBoxPanel()
        
        LoadingView = YMPageLoadingView(parentView: ParentView!)
    }
    
    func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.backgroundColor = YMColors.BackgroundGray
        
        
        SearchInput.EditEndCallback = SearchActions?.SearchInputEnded
        SearchInput.MaxCharCount = 20
        
        let searchIconPadding = UIView(frame: CGRect(x: 0, y: 0, width: 60.LayoutVal(), height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("PageGetMyDoctorsSearchIcon")
        searchIconPadding.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        
        SearchInput.SetLeftPadding(searchIconPadding)
        SearchInput.placeholder = "按姓名、疾病、医院、科室找专家"
        SearchInput.textColor = YMColors.PatientFontGreen
        
        SearchPanel.addSubview(SearchInput)
        SearchInput.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        
        SearchInput.backgroundColor = YMColors.White
        SearchInput.layer.cornerRadius = 10.LayoutVal()
        SearchInput.layer.masksToBounds = true
    }
    
    func DrawByDocPanel() {
        BodyView.addSubview(ByDocPanel)
        ByDocPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        ByDocPanel.layer.masksToBounds = true
        ByDocPanel.hidden = true
        ByDocPanel.backgroundColor = HexColor("#f9f9f9")
    }
    
    func DrawByHosPanel() {
        BodyView.addSubview(ByHosPanel)
        ByHosPanel.align(Align.UnderMatchingLeft, relativeTo: ByDocPanel, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        ByHosPanel.layer.masksToBounds = true
        ByHosPanel.hidden = true
        ByHosPanel.backgroundColor = HexColor("#f9f9f9")
    }
    
    func DrawByTagPanel() {
        BodyView.addSubview(ByTagPanel)
        ByTagPanel.align(Align.UnderMatchingLeft, relativeTo: ByHosPanel, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        ByTagPanel.layer.masksToBounds = true
        ByTagPanel.hidden = true
        ByTagPanel.backgroundColor = HexColor("#f9f9f9")
    }
    
    private func LoadSearchListByType(type: String, panel: UIView, data: [[String: AnyObject]], prevPanel: UIView) {
        panel.align(Align.UnderMatchingLeft, relativeTo: prevPanel, padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        if(0 == data.count) {
            return
        }
        
        let title = YMLayout.GetNomalLabel(type, textColor: YMColors.PatientFontGreen, fontSize: 22.LayoutVal())
        let titleView = UIView()

        panel.addSubview(titleView)
        titleView.anchorToEdge(Edge.Top, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 50.LayoutVal())
        titleView.addSubview(title)
        title.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: title.width, height: title.height)
        let titleBottomBorder = UIView()
        titleBottomBorder.backgroundColor = HexColor("#e0e0e0")
        titleView.addSubview(titleBottomBorder)
        titleBottomBorder.anchorToEdge(Edge.Bottom, padding: 0, width: titleView.width, height: YMSizes.OnPx)

        var cell: UIView? = titleView
        var cellCnt = 0
        
        for doc in data {
            cellCnt += 1
            cell = YMLayout.DrawCommonDocCell(doc, docPanel: panel, action: SearchActions!, selector: "DoctorTouched:".Sel(), prevCell: cell)
            cell?.backgroundColor = YMColors.None
            if (cellCnt > 1) {
                break
            }
        }
        
        if(data.count > 2) {
            let showMoreBtn = YMButton()
            showMoreBtn.setTitle("查看更多...", forState: UIControlState.Normal)
            showMoreBtn.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
            showMoreBtn.titleLabel?.font = YMFonts.YMDefaultFont(20.LayoutVal())
            panel.addSubview(showMoreBtn)
            showMoreBtn.align(Align.UnderMatchingLeft, relativeTo: cell!, padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
            showMoreBtn.addTarget(SearchActions!, action: "ShowMore:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
            showMoreBtn.UserObjectData = data
            cell = showMoreBtn
        }
        
        if (nil != cell) {
            YMLayout.SetViewHeightByLastSubview(panel, lastSubView: cell!)
        }
        LoadingView?.Hide()
    }
    
    func LoadSearchResult(data: [String: AnyObject]) {
        let byDocData = data["name"] as! [[String: AnyObject]]
        let byHosData = data["hospital"] as! [[String: AnyObject]]
        let byTagData = data["tag"] as! [[String: AnyObject]]
        
        YMLayout.ClearView(view: ByDocPanel)
        YMLayout.ClearView(view: ByHosPanel)
        YMLayout.ClearView(view: ByTagPanel)
        
        DocPanel.hidden = true
        ByDocPanel.hidden = false
        ByHosPanel.hidden = false
        ByTagPanel.hidden = false

        LoadSearchListByType("按医生", panel: ByDocPanel, data: byDocData, prevPanel: SearchPanel)
        LoadSearchListByType("按医院", panel: ByHosPanel, data: byHosData, prevPanel: ByDocPanel)
        LoadSearchListByType("按专长", panel: ByTagPanel, data: byTagData, prevPanel: ByHosPanel)
        
        
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: ByTagPanel)
    }
    
    func DrawTabPanel() {
        BodyView.addSubview(TabPanel)
        TabPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        TabPanel.backgroundColor = YMColors.PatientSearchBackgroundGray

        func BuildFilterBtn(text: String, selector: Selector, showDivider: Bool, prev: UIView?) -> YMTouchableView {
            let btn = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: selector)
            let icon = YMLayout.GetSuitableImageView("SearchTabArrow")
            let title = UILabel()
            
            TabPanel.addSubview(btn)
            if(nil == prev) {
                btn.anchorToEdge(Edge.Left, padding: 0, width: 187.5.LayoutVal(), height: 80.LayoutVal())
            } else {
                btn.align(Align.ToTheRightCentered, relativeTo: prev!, padding: 0, width: 187.5.LayoutVal(), height: 80.LayoutVal())
            }
            
            btn.backgroundColor = YMColors.None

            title.text = text
            title.textColor = YMColors.PatientFontGray
            title.font = YMFonts.YMDefaultFont(28.LayoutVal())
            title.sizeToFit()

            btn.addSubview(title)
            btn.addSubview(icon)

            title.anchorInCenter(width: title.width, height: title.height)
            icon.align(Align.ToTheRightCentered, relativeTo: title, padding: 14.LayoutVal(), width: icon.width, height: icon.height)
            
            if(true == showDivider) {
                let divider = UIView()
                divider.backgroundColor = YMColors.PatientFontGreen
                
                btn.addSubview(divider)
                divider.anchorToEdge(Edge.Right, padding: 0, width: YMSizes.OnPx, height: 30.LayoutVal())
            }
            return btn
        }
        
        var tabBtn = BuildFilterBtn("省市", selector: "ProvTabTouched:".Sel(), showDivider: true, prev: nil)
        tabBtn = BuildFilterBtn("医院", selector: "HosTabTouched:".Sel(), showDivider: true, prev: tabBtn)
        tabBtn = BuildFilterBtn("科室", selector: "DeptTabTouched:".Sel(), showDivider: true, prev: tabBtn)
        tabBtn = BuildFilterBtn("职称", selector: "JobtitleTabTouched:".Sel(), showDivider: false, prev: tabBtn)
    }
    
    func DrawDoctorPanel() {
        BodyView.addSubview(DocPanel)
        DocPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 20.LayoutVal(), width: YMSizes.PageWidth, height: 0)
    }
    
    func DrawBoxPanel() {
        ParentView?.addSubview(BoxPanel)
        BoxPanel.fillSuperview()
        BoxPanel.hidden = true
        
        
        
        BoxMask = YMLayout.GetTouchableView(useObject: SearchActions!, useMethod: "HideBox:".Sel())
        BoxMask?.backgroundColor = HexColor("#000000", 0.5)
        BoxPanel.addSubview(BoxMask!)
        BoxMask?.fillSuperview()
        
        BoxPanel.addSubview(BoxInner)
        BoxInner.anchorToEdge(Edge.Top, padding: 320.LayoutVal(), width: 480.LayoutVal(), height: 430.LayoutVal())
        
        BoxInner.backgroundColor = YMColors.White
        BoxInner.layer.cornerRadius = 20.LayoutVal()
        BoxInner.layer.masksToBounds = true
        
        BoxInner.addSubview(BoxInfoPanel)
        BoxInfoPanel.anchorToEdge(Edge.Top, padding: 0, width: BoxInner.width, height: BoxInner.height)
        
        let appointmentBtn = UIButton()
        let proxyBtn = UIButton()
        
        appointmentBtn.setTitle("预约面诊", forState: UIControlState.Normal)
        appointmentBtn.backgroundColor = YMColors.White
        appointmentBtn.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
        appointmentBtn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        
        proxyBtn.setTitle("请他代约", forState: UIControlState.Normal)
        proxyBtn.backgroundColor = YMColors.White
        proxyBtn.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
        proxyBtn.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        
        BoxInner.addSubview(appointmentBtn)
        BoxInner.addSubview(proxyBtn)
        
        BoxInner.groupAgainstEdge(group: Group.Horizontal, views: [appointmentBtn, proxyBtn],
                                  againstEdge: Edge.Bottom, padding: 0, width: BoxInner.width / 2, height: 80.LayoutVal())
        
        let buttonTopBorder = UIView()
        let buttonDivider = UIView()
        
        buttonTopBorder.backgroundColor = YMColors.BackgroundGray
        buttonDivider.backgroundColor = YMColors.BackgroundGray
        
        BoxInner.addSubview(buttonTopBorder)
        BoxInner.addSubview(buttonDivider)
        
        buttonTopBorder.anchorToEdge(Edge.Bottom, padding: 80.LayoutVal(), width: BoxInner.width, height: YMSizes.OnPx)
        buttonDivider.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.OnPx, height: 80.LayoutVal())
        
        appointmentBtn.addTarget(SearchActions!, action: "AppointmentTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        proxyBtn.addTarget(SearchActions!, action: "ProxyTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func LoadDoctorToBox(data: [String: AnyObject]) {
        SelectedDoc = data
        
        let head = data["head_url"] as! String
        let name = data["name"] as! String
        let hospital = data["hospital"] as! [String: AnyObject]
        let department = data["department"] as! [String: AnyObject]
        let jobTitle = data["job_title"] as? String
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let userHeadBackground = YMLayout.GetSuitableImageView("HeadImageBorder")
        
        nameLabel.text = name
        nameLabel.textColor = YMColors.PatientFontGray
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.PatientFontGray
        
        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.PatientFontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = department["name"] as? String
        deptLabel.textColor = YMColors.PatientFontGray
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = hospital["name"] as? String
        hosLabel.textColor = YMColors.PatientFontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        BoxInfoPanel.addSubview(userHeadBackground)
        BoxInfoPanel.addSubview(nameLabel)
        BoxInfoPanel.addSubview(divider)
        BoxInfoPanel.addSubview(jobTitleLabel)
        BoxInfoPanel.addSubview(deptLabel)
        BoxInfoPanel.addSubview(hosLabel)
        
        userHeadBackground.anchorToEdge(Edge.Top, padding: 50.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        divider.align(Align.UnderCentered, relativeTo: userHeadBackground, padding: 30.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        nameLabel.align(Align.ToTheLeftCentered, relativeTo: divider, padding: 10.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 10.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        deptLabel.align(Align.UnderCentered, relativeTo: divider, padding: 10.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderCentered, relativeTo: deptLabel, padding: 10.LayoutVal(), width: hosLabel.width, height: hosLabel.height)
        
        YMLayout.LoadImageFromServer(userHeadBackground, url: head)
        
        
        BoxPanel.hidden = false
    }
    
    func HideBox() {
        YMLayout.ClearView(view: BoxInfoPanel)
        BoxPanel.hidden = true
        SelectedDoc = nil
    }
    
    func LoadMoreSearchData(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: DocPanel)
        
        ByDocPanel.hidden = true
        ByHosPanel.hidden = true
        ByTagPanel.hidden = true

        DocPanel.hidden = false
        LoadData(data)
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        var cell: YMTouchableView? = nil
        var cellCnt = 0
        for doc in data {
            cellCnt += 1
            cell = YMLayout.DrawCommonDocCell(doc, docPanel: DocPanel, action: SearchActions!, selector: "DoctorTouched:".Sel(), prevCell: cell)
            cell?.backgroundColor = YMColors.None
            if (cellCnt > 50) {
                break
            }
        }

        if (nil != cell) {
            let topBorder = UIView()
            topBorder.backgroundColor = HexColor("#e0e0e0")
            DocPanel.addSubview(topBorder)
            topBorder.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            YMLayout.SetViewHeightByLastSubview(DocPanel, lastSubView: cell!)
        }
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: DocPanel)
        LoadingView?.Hide()
    }
    
    func Clear() {
        YMLayout.ClearView(view: ByDocPanel)
        YMLayout.ClearView(view: ByHosPanel)
        YMLayout.ClearView(view: ByTagPanel)
        YMLayout.ClearView(view: DocPanel)
        
        SearchInput.text = nil
        ByDocPanel.hidden = true
        ByHosPanel.hidden = true
        ByTagPanel.hidden = true
        DocPanel.hidden = false
        
        HideBox()
        LoadingView?.Hide()
    }
}




























