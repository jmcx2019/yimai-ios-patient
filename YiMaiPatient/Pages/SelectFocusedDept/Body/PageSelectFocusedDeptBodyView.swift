//
//  PageSelectFocusedDeptBodyView.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/22.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageSelectFocusedDeptBodyView: PageBodyView {
    var DeptActions: PageSelectFocusedDeptActions!
    var AllTags = [YMLabel]()
    var TagPanel = UIView()
    var SelectedTagPanel = UIView()
    var SearchPanel = UIView()
    var SearchInput: YMTextField!
    var OrgData: [[String: AnyObject]] = [[String: AnyObject]]()
    
    var SelectedTag = [String: String]()
    var NextStepBtn = YMButton()
    var SaveBtn = YMButton()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        DeptActions = PageSelectFocusedDeptActions(navController: NavController!, target: self)
        DrawSearchPanel()
        DrawSavepButton()
    }
    
    func DrawSavepButton() {
        ParentView?.addSubview(SaveBtn)
        SaveBtn.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 98.LayoutVal())
        SaveBtn.setTitle("保存", forState: UIControlState.Normal)
        SaveBtn.titleLabel?.font = YMFonts.YMDefaultFont(36.LayoutVal())
        
        SaveBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        SaveBtn.backgroundColor = YMColors.FontLighterGray
        SaveBtn.enabled = false
        SaveBtn.addTarget(DeptActions, action: "SaveSelectedTag:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        SaveBtn.hidden = true
    }
    
    func DrawNextStepButton(topView: UIView) {
        topView.addSubview(NextStepBtn)
        NextStepBtn.setTitle("下一步", forState: UIControlState.Normal)
        NextStepBtn.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        
        NextStepBtn.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
        NextStepBtn.backgroundColor = YMColors.None
        NextStepBtn.addTarget(DeptActions, action: "TagSelectNextStep:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        NextStepBtn.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 28.LayoutVal(), width: 100.LayoutVal(), height: 40.LayoutVal())
    }
    
    func BuildSelectedTagString() -> String {
        if(0 == SelectedTag.count) {
            return ""
        }
        
        var tagArr = [String]()
        for (_,v) in SelectedTag {
            tagArr.append(v)
        }
        
        return tagArr.joinWithSeparator(",")
    }
    
    func GetTaglist() -> String {
        var ret = ""
        var dictForRet = [String: AnyObject]()

        dictForRet["tag_list"] = BuildSelectedTagString()
        ret = YMVar.TransObjectToString(dictForRet)
        return ret
    }
    
    func SwapTagStatus(tag: YMLabel) {
        var userData = tag.UserObjectData as! [String: AnyObject]
        let selected = YMVar.GetStringByKey(userData, key: "selected")
        let tagId = YMVar.GetStringByKey(userData, key: "id")
        
        if("0" == selected) {
            tag.backgroundColor = YMColors.PatientFontGreen
            tag.textColor = YMColors.White
            userData["selected"] = "1"
            SelectedTag[tagId] = tagId
        } else {
            tag.backgroundColor = YMColors.None
            tag.textColor = YMColors.PatientFontGreen
            userData["selected"] = "0"
            SelectedTag.removeValueForKey(tagId)
        }
        
        tag.UserObjectData = userData

        CheckIfChange()
    }
    
    func EnableSaveButton() {
        SaveBtn.backgroundColor = YMColors.PatientFontGreen
        SaveBtn.enabled = true
    }
    
    func DisableSaveButton() {
        SaveBtn.backgroundColor = YMColors.FontLighterGray
        SaveBtn.enabled = false
    }
    
    func CheckIfChange() {
        let tagsJson = YMVar.GetStringByKey(YMVar.MyInfo, key: "tags")
        if(YMValueValidator.IsBlankString(tagsJson)) {
            //no selected tags
            if(SelectedTag.count > 0) {
                EnableSaveButton()
            } else {
                DisableSaveButton()
            }
            return
        }
        
        let selectedTags = YMVar.TryToGetDictFromJsonStringData(tagsJson)
        if(nil == selectedTags) {
            //no selected tags
            if(SelectedTag.count > 0) {
                EnableSaveButton()
            } else {
                DisableSaveButton()
            }
            return
        }
        
        let tagIdList = selectedTags!["tag_list"] as? String
        if(YMValueValidator.IsBlankString(tagIdList)) {
            //no selected tags
            if(SelectedTag.count > 0) {
                EnableSaveButton()
            } else {
                DisableSaveButton()
            }
            return
        }
        
        let newTagList = tagIdList!.componentsSeparatedByString(",")
        if(newTagList.count != SelectedTag.count) {
            EnableSaveButton()
            return
        }
        
        var enableFlag = false
        for id in newTagList {
            var idUnselected = true
            for (_, preId) in SelectedTag {
                if(id == preId) {
                    idUnselected = false
                    break
                }
            }
            if(idUnselected) {
                enableFlag = true
                break
            }
        }
        
        if(enableFlag) {
            EnableSaveButton()
        } else {
            DisableSaveButton()
        }
    }
    
    func GetSelectedTagArr() {
        SelectedTag.removeAll()
        let tagsJson = YMVar.GetStringByKey(YMVar.MyInfo, key: "tags")
        if(YMValueValidator.IsBlankString(tagsJson)) {
            //no selected tags
            return
        }
        
        let selectedTags = YMVar.TryToGetDictFromJsonStringData(tagsJson)
        if(nil == selectedTags) {
            //no selected tags
            return
        }
        
        let tagIdList = selectedTags!["tag_list"] as? String
        if(YMValueValidator.IsBlankString(tagIdList)) {
            //no selected tags
            return
        }
        
        for id in tagIdList!.componentsSeparatedByString(",") {
            SelectedTag[id] = id
        }
    }
    
//    func DrawSelectedTagPanel() {
//        BodyView.addSubview(SelectedTagPanel)
//        SelectedTagPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
//        YMLayout.ClearView(view: SelectedTagPanel)
//        
//        let tagsJson = YMVar.GetStringByKey(YMVar.MyInfo, key: "tags")
//        if(YMValueValidator.IsBlankString(tagsJson)) {
//            //no selected tags
//            return
//        }
//        
//        let selectedTags = YMVar.TryToGetDictFromJsonStringData(tagsJson)
//        if(nil == selectedTags) {
//            //no selected tags
//            return
//        }
//        
//        let tagIdList = selectedTags!["tag_list"] as? String
//        if(YMValueValidator.IsBlankString(tagIdList)) {
//            //no selected tags
//            return
//        }
//        
//        var tagSelectedArr = [[String: AnyObject]]()
//        for id in tagIdList!.componentsSeparatedByString(",") {
//            for dept in OrgData {
//                let deptId = YMVar.GetStringByKey(dept, key: "id")
//                let deptName = YMVar.GetStringByKey(dept, key: "name")
//                if(id == deptId) {
//                    let tagInfo: [String: AnyObject] = ["text": deptName, id: id, "userData": dept]
//                    tagSelectedArr.append(tagInfo)
//                    SelectedTag[deptId] = tagInfo
//                }
//            }
//        }
//
//        DrawSelectedTags(tagSelectedArr)
//    }
    
    func DrawSelectedTags(tagList: [[String: AnyObject]]) {
        let lastLine = YMLayout.DrawTagList(tagList, tagPanel: SelectedTagPanel, tagBuilder: TagBuilder, lineWidth: 670.LayoutVal(), lineHeight: 40.LayoutVal(),
                                            firstLineXPos: 40.LayoutVal(), firstLineYPos: 0, lineSpace: 30.LayoutVal(),
                                            tagSpace: 10.LayoutVal(), tagInnerPadding: 20.LayoutVal())
        YMLayout.SetViewHeightByLastSubview(SelectedTagPanel, lastSubView: lastLine)
    }
    
    func DoSearch(input: YMTextField) {
        let searchKey = input.text
        FullPageLoading.Show()
        YMDelay(0.1) { 
            self.DrawSearchResult(searchKey)
        }
    }
    
    func DrawSearchResult(searchKey: String?) {
        if(YMValueValidator.IsBlankString(searchKey)) {
            LoadData(OrgData)
        } else {
            var searchResultData = [[String: AnyObject]]()
            
            for dept in OrgData {
                let deptName = YMVar.GetStringByKey(dept, key: "name")
                if(deptName.containsString(searchKey!)) {
                    searchResultData.append(dept)
                }
            }
            
            LoadData(searchResultData, forSearch: true)
        }
        FullPageLoading.Hide()
    }
    
    func DrawSearchPanel() {
        if(nil != SearchInput) {
            SearchPanel.removeFromSuperview()
            BodyView.addSubview(SearchPanel)
            SearchPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 120.LayoutVal())
            return
        }
        let inputParam = TextFieldCreateParam()
        inputParam.BackgroundColor = YMColors.White
        inputParam.FontSize = 28.0.LayoutVal()
        inputParam.Placholder = "搜索"
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

    func TagBuilder(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView {

        let tag = YMLayout.GetNomalLabel(tagText, textColor: YMColors.PatientFontGreen, fontSize: 26.LayoutVal())
        tag.frame = CGRect(x: 0, y: 0, width: tagInnerPadding*2 + tag.width, height: tagHeight)
        
        tag.textAlignment = NSTextAlignment.Center
        tag.layer.borderColor = YMColors.PatientFontGreen.CGColor
        tag.layer.borderWidth = 2.LayoutVal()
        tag.layer.masksToBounds = true
        tag.layer.cornerRadius = 10.LayoutVal()

        tag.UserObjectData = userData
        
        let gr = UITapGestureRecognizer(target: DeptActions, action: "TagTouched:".Sel())
        tag.userInteractionEnabled = true
        tag.addGestureRecognizer(gr)
        AllTags.append(tag)
        
        let tagData = userData as! [String: AnyObject]
        let tagId = YMVar.GetStringByKey(tagData, key: "id")
        if(nil != SelectedTag[tagId]) {
            SwapTagStatus(tag)
        }
        return tag
    }

    func LoadData(data: [[String: AnyObject]], forSearch: Bool = false) {
        
        if(!forSearch) {
            OrgData = data
        }
        AllTags.removeAll()
        
        var tagList = [[String: AnyObject]]()
        for tag in data {
            let newTag: [String: AnyObject] = ["text": tag["name"] as! String, "id": "\(tag["id"]!)", "selected": "0", "userData": tag]
            tagList.append(newTag)
        }

        BodyView.addSubview(TagPanel)
        TagPanel.align(Align.UnderMatchingLeft, relativeTo: SearchPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        YMLayout.ClearView(view: TagPanel)
        
        let lastLine = YMLayout.DrawTagList(tagList, tagPanel: TagPanel, tagBuilder: TagBuilder,
                                            lineWidth: 670.LayoutVal(), lineHeight: 40.LayoutVal(),
                             firstLineXPos: 40.LayoutVal(), firstLineYPos: 0, lineSpace: 30.LayoutVal(),
                             tagSpace: 10.LayoutVal(), tagInnerPadding: 20.LayoutVal())
        
        YMLayout.SetViewHeightByLastSubview(TagPanel, lastSubView: lastLine)
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: TagPanel, padding: 128.LayoutVal())
    }
}




















