//
//  PageSelectCityBodyView.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/14.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

public class PageSelectCityBodyView: PageBodyView{
    var CityActions: PageSelectCityActions!
    var HotCitiesPanel = UIView()
    var SelectedCityPanel = UIView()
    var SearchPanel = UIView()
    var AllCitiesPanel = UIView()
    var SearchResultPanel = UIView()
    var SearchInput: YMTextField!
    
    let SelectedCityLabel = ActiveLabel()
    
    var SaveButton: YMButton!
    
    var HotCityCell = [YMLabel]()
    var AllCityCell = [YMLabel]()
    var AllCityCellForSearchResult = [YMLabel]()
    
    var SelectedCity: YMLabel? = nil
    var SelectedCityConfirm: YMLabel? = nil
    
    var SearchFlag = false

    override func ViewLayout() {
        super.ViewLayout()
        
        CityActions = PageSelectCityActions(navController: NavController!, target: self)
        DrawSearchPanel()
        DrawSelectedCityPanel()
        DrawSaveButton()
    }
    
    func SetCityCellStatus(cell: YMLabel?) {
        var cellData = cell?.UserObjectData as? [String: AnyObject]
        let selectedStatus = YMVar.GetStringByKey(cellData, key: "selected")

        var keepCell: YMLabel? = cell
        if(nil == cell || "1" == selectedStatus) {
            keepCell = nil
            SelectedCity = nil
            SaveButton.enabled = false
            SaveButton.backgroundColor = YMColors.FontLighterGray
        } else {
            cellData?["selected"] = "1"
            SelectedCity = cell
            cell?.backgroundColor = YMColors.PatientFontGreen
            cell?.textColor = YMColors.White
            cell?.UserObjectData = cellData
            SaveButton.enabled = true
            SaveButton.backgroundColor = YMColors.PatientFontGreen
        }
        
        ClearCellSelectedFlag(HotCityCell, theCell: keepCell)

        if(SearchFlag) {
            ClearCellSelectedFlag(AllCityCellForSearchResult, theCell: keepCell)
        } else {
            ClearCellSelectedFlag(AllCityCell, theCell: keepCell)
        }
    }
    
    func ClearCellSelectedFlag(list: [YMLabel], theCell: YMLabel? = nil) {
        for cell in list {
            if(cell == theCell) {
                continue
            }
            var cellData = cell.UserObjectData as! [String: AnyObject]
            cellData["selected"] = "0"
            cell.UserObjectData = cellData
            cell.backgroundColor = YMColors.White
            cell.textColor = YMColors.PatientFontGreen
        }
    }
    
    func DrawSaveButton() {
        SaveButton = YMButton()
        ParentView?.addSubview(SaveButton)
        SaveButton.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
        SaveButton.setTitle("保存", forState: UIControlState.Normal)
        SaveButton.titleLabel?.font = YMFonts.YMDefaultFont(36.LayoutVal())
        
        SaveButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SaveButton.backgroundColor = YMColors.FontLighterGray
        SaveButton.addTarget(CityActions, action: "SaveCityTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func DoSearch(input: YMTextField) {
        let sortedCity = YMLocalData.GetData("CitiyList") as? [String: [[String: AnyObject]]]
        
        if(nil == sortedCity) {
            SearchFlag = false
            return
        }

        FullPageLoading.Show()
        let searchKey = input.text!
        if(YMValueValidator.IsBlankString(searchKey)) {
            AllCitiesPanel.hidden = false
            SearchResultPanel.hidden = true
            SearchFlag = false
            SetCityCellStatus(nil)
            YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: AllCitiesPanel, padding: 98.LayoutVal())
            self.FullPageLoading.Hide()
            return
        }

        var result = [String: [[String: AnyObject]]]()
        for (alpha, cities) in sortedCity! {
            for city in cities {
                let cityName = YMVar.GetStringByKey(city, key: "name")
                if(cityName.containsString(searchKey)) {
                    if(nil == result[alpha]) {
                        result[alpha] = [[String: AnyObject]]()
                    }
                    result[alpha]?.append(city)
                }
            }
        }

        AllCitiesPanel.hidden = true
        SearchResultPanel.hidden = false
        YMDelay(0.1) {
            self.DrawCities(result, forSearchResult: true)
            self.SetCityCellStatus(nil)
            self.FullPageLoading.Hide()
        }
    }
    
    func DrawSearchPanel() {
        let inputParam = TextFieldCreateParam()
        inputParam.BackgroundColor = YMColors.White
        inputParam.FontSize = 28.0.LayoutVal()
        inputParam.Placholder = "输入城市名称查询（最多20字）"
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(inputParam, maxCharCount: 20)
        
        let searchIconPadding = UIView(frame: CGRect(x: 0, y: 0, width: 60.LayoutVal(), height: 60.LayoutVal()))
        let searchIcon = YMLayout.GetSuitableImageView("PageGetMyDoctorsSearchIcon")
        searchIconPadding.addSubview(searchIcon)
        searchIcon.anchorInCenter(width: searchIcon.width, height: searchIcon.height)
        
        SearchInput.SetLeftPadding(searchIconPadding)
        
        SearchInput.EditEndCallback = DoSearch
        
        BodyView.addSubview(SearchPanel)
        SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
        SearchPanel.addSubview(SearchInput)
        
        SearchInput.anchorInCenter(width: 690.LayoutVal(), height: 60.LayoutVal())
    }
    
    func HotCityCellBuilder(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView {
        let tag = YMLabel()
        tag.textAlignment = NSTextAlignment.Center
        tag.font = YMFonts.YMDefaultFont(30.LayoutVal())
        tag.textColor = YMColors.PatientFontGreen
        tag.backgroundColor = YMColors.White
        tag.layer.cornerRadius = 10.LayoutVal()
        tag.layer.masksToBounds = true
        
        tag.text = tagText
        
        tag.sizeToFit()
        tag.frame = CGRect(x: 0, y: 0, width: tag.width + 80.LayoutVal(), height: 60.LayoutVal())
        tag.UserObjectData = ["selected": "0", "userData": userData]
        tag.userInteractionEnabled = true
        
        let tapGr = UITapGestureRecognizer(target: CityActions, action: "CityTouched:".Sel())
        tag.addGestureRecognizer(tapGr)
        
        HotCityCell.append(tag)
        
        return tag
    }
    
    func CityCellBuilder(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView {
        let tag = YMLabel()
        tag.textAlignment = NSTextAlignment.Center
        tag.font = YMFonts.YMDefaultFont(30.LayoutVal())
        tag.textColor = YMColors.PatientFontGreen
        tag.backgroundColor = YMColors.White
        tag.layer.cornerRadius = 10.LayoutVal()
        tag.layer.masksToBounds = true
        
        tag.text = tagText
        
        tag.sizeToFit()
        tag.frame = CGRect(x: 0, y: 0, width: tag.width + 80.LayoutVal(), height: 60.LayoutVal())
        tag.UserObjectData = ["selected": "0", "userData": userData]
        tag.userInteractionEnabled = true

        let tapGr = UITapGestureRecognizer(target: CityActions, action: "CityTouched:".Sel())
        tag.addGestureRecognizer(tapGr)
        
        AllCityCell.append(tag)

        return tag
    }
    
    func DrawSelectedCityPanel() {
        BodyView.addSubview(SelectedCityPanel)
        SelectedCityPanel.align(Align.UnderCentered, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 160.LayoutVal())
        
        YMLayout.ClearView(view: SelectedCityPanel)
        let titleLabel = YMLayout.GetNomalLabel("已选择城市", textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        SelectedCityPanel.addSubview(titleLabel)
        SelectedCityPanel.addSubview(SelectedCityLabel)
        
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        SelectedCityLabel.textAlignment = NSTextAlignment.Center
        SelectedCityLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        SelectedCityLabel.textColor = YMColors.White
        SelectedCityLabel.backgroundColor = YMColors.PatientFontGreen

        SelectedCityLabel.layer.cornerRadius = 10.LayoutVal()
        SelectedCityLabel.layer.masksToBounds = true
        
        let selectedCity = YMVar.MyInfo["city"] as? [String: AnyObject]
        SelectedCityLabel.text = YMVar.GetStringByKey(selectedCity, key: "name", defStr: "尚未选择")
        
        SelectedCityLabel.sizeToFit()
        SelectedCityLabel.align(Align.UnderMatchingLeft, relativeTo: titleLabel, padding: 20.LayoutVal(),
                                width: SelectedCityLabel.width + 110.LayoutVal(), height: 60.LayoutVal())
    }
    
    func DrawHotCityPanel(data: [[String: AnyObject]]) {
        BodyView.addSubview(HotCitiesPanel)
        HotCitiesPanel.align(Align.UnderMatchingLeft, relativeTo: SelectedCityPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        YMLayout.ClearView(view: HotCitiesPanel)
        
        let titleLabel = YMLayout.GetNomalLabel("热门城市", textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        let citiesPanel = UIView()
        HotCitiesPanel.addSubview(titleLabel)
        HotCitiesPanel.addSubview(citiesPanel)

        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        citiesPanel.anchorToEdge(Edge.Top, padding: 50.LayoutVal() + titleLabel.height, width: YMSizes.PageWidth, height: 0)

        var citiesList = [[String: AnyObject]]()
        for city in data {
            var newCityData = city
            newCityData["text"] = YMVar.GetStringByKey(city, key: "name")
            citiesList.append(newCityData)
        }
        
        HotCityCell.removeAll()
        let lastLine = YMLayout.DrawTagList(citiesList, tagPanel: citiesPanel, tagBuilder: HotCityCellBuilder, lineWidth: 670.LayoutVal(), lineHeight: 60.LayoutVal(),
                                            firstLineXPos: 40.LayoutVal(), firstLineYPos: 0, lineSpace: 30.LayoutVal(),
                                            tagSpace: 10.LayoutVal(), tagInnerPadding: 20.LayoutVal())

        YMLayout.SetViewHeightByLastSubview(citiesPanel, lastSubView: lastLine, bottomPadding: 20.LayoutVal())
        YMLayout.SetViewHeightByLastSubview(HotCitiesPanel, lastSubView: citiesPanel)
    }
    
    func LoadData(hotCities: [[String: AnyObject]], cities: [[String: AnyObject]]) {
        var sortedCities = [String: [[String: AnyObject]]]()

        YMLocalData.SaveData(hotCities, key: "HotCities")
        DrawHotCityPanel(hotCities)
        for city in cities {
            let cityName = YMVar.GetStringByKey(city, key: "name").TransformToPinYin().uppercaseString
            let firstChar = "\(cityName.characters.first!)" //cityName.substringToIndex(cityName.startIndex.advancedBy(1))
            let prevList = sortedCities[firstChar]
            if(nil == prevList) {
                sortedCities[firstChar] = [[String: AnyObject]]()
            }

            sortedCities[firstChar]?.append(city)
        }

        YMLocalData.SaveData(sortedCities, key: "CitiyList")
        DrawCities(sortedCities)
    }
    
    func DrawCities(data: [String: [[String: AnyObject]]], forSearchResult: Bool = false) {
        let alphaMap = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var targetPanel = AllCitiesPanel
        
        let cachedCellList = AllCityCell
        AllCityCell.removeAll()
        AllCityCellForSearchResult.removeAll()
        SearchFlag = forSearchResult
        if(forSearchResult) {
            BodyView.addSubview(SearchResultPanel)
            SearchResultPanel.align(Align.UnderMatchingLeft, relativeTo: HotCitiesPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
            YMLayout.ClearView(view: SearchResultPanel)
            targetPanel = SearchResultPanel
        } else {
            BodyView.addSubview(AllCitiesPanel)
            AllCitiesPanel.align(Align.UnderMatchingLeft, relativeTo: HotCitiesPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
            YMLayout.ClearView(view: AllCitiesPanel)
        }
        
        if(0 == data.count) {
            let titleLabel = YMLayout.GetNomalLabel("没有搜索到城市", textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
            AllCitiesPanel.addSubview(titleLabel)
            titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
            return
        }

        func DrawCitiesPanel(index: String, cities: [[String: AnyObject]]?, prev: UIView?) -> UIView? {
            if(nil == cities) {
                return prev
            }
            
            let panel = UIView()
            targetPanel.addSubview(panel)
            if(nil == prev) {
                panel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 0)
            } else {
                panel.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 0)
            }
            
            let titleLabel = YMLayout.GetNomalLabel(index, textColor: YMColors.FontGray, fontSize: 30.LayoutVal())
            let citiesPanel = UIView()
            panel.addSubview(titleLabel)
            panel.addSubview(citiesPanel)
            
            titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
            citiesPanel.anchorToEdge(Edge.Top, padding: 50.LayoutVal() + titleLabel.height, width: YMSizes.PageWidth, height: 0)
            
            var citiesList = [[String: AnyObject]]()
            for city in cities! {
                var newCityData = city
                newCityData["text"] = YMVar.GetStringByKey(city, key: "name")
                citiesList.append(newCityData)
            }
            
            let lastLine = YMLayout.DrawTagList(citiesList, tagPanel: citiesPanel, tagBuilder: CityCellBuilder, lineWidth: 670.LayoutVal(), lineHeight: 60.LayoutVal(),
                                                firstLineXPos: 40.LayoutVal(), firstLineYPos: 0, lineSpace: 30.LayoutVal(),
                                                tagSpace: 10.LayoutVal(), tagInnerPadding: 20.LayoutVal())
            
            YMLayout.SetViewHeightByLastSubview(citiesPanel, lastSubView: lastLine, bottomPadding: 20.LayoutVal())
            YMLayout.SetViewHeightByLastSubview(panel, lastSubView: citiesPanel)
            
            
            return panel
        }
        
        var prevCitiesPanel: UIView? = nil
        for alpha in alphaMap.characters {
            let idx = "\(alpha)"
            prevCitiesPanel = DrawCitiesPanel(idx, cities: data[idx], prev: prevCitiesPanel)
        }
        
        if(SearchFlag) {
            AllCityCellForSearchResult = AllCityCell
            AllCityCell = cachedCellList
        }
        
        YMLayout.SetViewHeightByLastSubview(targetPanel, lastSubView: prevCitiesPanel, bottomPadding: 20.LayoutVal())
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: targetPanel, padding: 98.LayoutVal())
    }
}










