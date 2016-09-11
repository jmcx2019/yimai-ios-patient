//
//  PageGetMyDoctorsBodyView.swift
//  YiMaiPatient
//
//  Created by superxing on 16/9/9.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon
import Kingfisher
import ChameleonFramework

public class PageGetMyDoctorsBodyView: PageBodyView {
    var DoctorsActions: PageGetMyDoctorsActions? = nil
    var LoadingView: YMPageLoadingView? = nil
    
    let SearchPanel = UIView()
    let SearchInput = YMTextField(aDelegate: nil)
    let MyDoctorsPanel = UIView()
    var BoxPanel = UIView()
    var BoxMask: YMTouchableView? = nil
    let BoxInner = UIView()
    let BoxInfoPanel = UIView()
    
    var SelectedDoc: [String: AnyObject]? = nil
    
    override public func ViewLayout() {
        super.ViewLayout()
        
        BodyView.backgroundColor = YMColors.BackgroundGray
        DoctorsActions = PageGetMyDoctorsActions(navController: self.NavController!, target: self)
        DrawSearchPanel()
        
        LoadingView = YMPageLoadingView(parentView: self.BodyView)
        DrawDoctorsPanel()
        
        DrawBoxPanel()
    }
    
    func DrawSearchPanel() {
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.backgroundColor = YMColors.BackgroundGray
        
        
        SearchInput.EditEndCallback = DoctorsActions?.SearchInputEnded
        SearchInput.MaxCharCount = 20
        
        let searchIconPadding = UIView(frame: CGRect(x: 0, y: 0, width: 60.LayoutVal(), height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("PageGetMyDoctorsSearchIcon")
        searchIconPadding.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        
        SearchInput.SetLeftPadding(searchIconPadding)
        SearchInput.placeholder = "搜索"
        SearchInput.textColor = YMColors.PatientFontGreen
        
        SearchPanel.addSubview(SearchInput)
        SearchInput.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
        
        SearchInput.backgroundColor = YMColors.White
        SearchInput.layer.cornerRadius = 10.LayoutVal()
        SearchInput.layer.masksToBounds = true
    }
    
    func DrawDoctorsPanel() {
        BodyView.addSubview(MyDoctorsPanel)
        MyDoctorsPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        
        var cell: YMTouchableView? = nil
        for doc in data {
            cell = YMLayout.DrawCommonDocCell(doc, docPanel: MyDoctorsPanel, action: DoctorsActions!, selector: "DoctorTouched:".Sel(), prevCell: cell)
        }
        
        if (nil != cell) {
            YMLayout.SetViewHeightByLastSubview(MyDoctorsPanel, lastSubView: cell!)
        }
        LoadingView?.Hide()
    }
    
    func Clear() {
        SearchInput.text = ""
        HideBox()
        YMLayout.ClearView(view: MyDoctorsPanel)
        MyDoctorsPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
    }
    
    func HideBox() {
        YMLayout.ClearView(view: BoxInfoPanel)
        BoxPanel.hidden = true
        SelectedDoc = nil
    }
    
    func DrawBoxPanel() {
        ParentView?.addSubview(BoxPanel)
        BoxPanel.fillSuperview()
        BoxPanel.hidden = true
        
        

        BoxMask = YMLayout.GetTouchableView(useObject: DoctorsActions!, useMethod: "HideBox:".Sel())
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
        
        appointmentBtn.addTarget(DoctorsActions!, action: "AppointmentTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        proxyBtn.addTarget(DoctorsActions!, action: "ProxyTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
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
}




























