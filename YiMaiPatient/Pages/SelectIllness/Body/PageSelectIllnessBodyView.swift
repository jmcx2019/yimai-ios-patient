//
//  PageSelectIllnessBodyView.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/24.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import Neon

class PageSelectIllnessBodyView: PageBodyView {
    var IllnessActions: PageSelectIllnessActions!
    var SelectedTagList: [[String: AnyObject]] = [[String: AnyObject]]()
    var SaveBtn = YMButton()
    var SelectedTag = [String: String]()

    override func ViewLayout() {
        super.ViewLayout()

        IllnessActions = PageSelectIllnessActions(navController: NavController!, target: self)
    }
    
    func GetTagListToSave() -> String {
        let tags = GetSelectedTagList()
        let illness = SelectedTag.keys
        
        let retDict = ["tag_list": tags.joinWithSeparator(","), "illness": illness.joinWithSeparator(",")]
        
        return YMVar.TransObjectToString(retDict)
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
    }
    
    func DrawSaveButton(topView: UIView) {
        topView.addSubview(SaveBtn)
        SaveBtn.setTitle("保存", forState: UIControlState.Normal)
        SaveBtn.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        
        SaveBtn.setTitleColor(YMColors.PatientFontGreen, forState: UIControlState.Normal)
        SaveBtn.backgroundColor = YMColors.None
        SaveBtn.addTarget(IllnessActions, action: "TagSave:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        SaveBtn.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 28.LayoutVal(), width: 100.LayoutVal(), height: 40.LayoutVal())
    }
    
    func GetSelectedTagList() -> [String] {
        var ret = [String]()
        let tagsJson = YMVar.GetStringByKey(YMVar.MyInfo, key: "tags")
        if(YMValueValidator.IsBlankString(tagsJson)) {
            //no selected tags
            return ret
        }
        
        let selectedTags = YMVar.TryToGetDictFromJsonStringData(tagsJson)
        if(nil == selectedTags) {
            //no selected tags
            return ret
        }
        
        let tagIdList = selectedTags!["tag_list"] as? String
        if(YMValueValidator.IsBlankString(tagIdList)) {
            //no selected tags
            return ret
        }
        
        for id in tagIdList!.componentsSeparatedByString(",") {
            ret.append(id)
        }
        
        return ret
    }
    
    func DrawBlankContent() {
        let label = YMLayout.GetNomalLabel("尚未选择标签", textColor: YMColors.WarningFontColor, fontSize: 30.LayoutVal())
        BodyView.addSubview(label)
        label.anchorInCenter(width: label.width, height: label.height)
    }
    
    func BuildTag(text: String, userData: AnyObject? = nil) -> YMLabel {
        let tag = YMLayout.GetNomalLabel(text, textColor: YMColors.White, fontSize: 26.LayoutVal())
        
        tag.frame = CGRect(x: 0, y: 0, width: tag.width + 80.LayoutVal(), height: 40.LayoutVal())
        tag.textAlignment = NSTextAlignment.Center
        tag.layer.borderColor = YMColors.PatientFontGreen.CGColor
        tag.layer.borderWidth = 2.LayoutVal()
        tag.layer.masksToBounds = true
        tag.layer.cornerRadius = 10.LayoutVal()
        
        tag.UserObjectData = userData
        
        return tag
    }
    
    func TagBuilder(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView {
        
        let tag = BuildTag(tagText, userData: userData)
        tag.textColor = YMColors.PatientFontGreen

        let gr = UITapGestureRecognizer(target: IllnessActions, action: "TagTouched:".Sel())
        tag.userInteractionEnabled = true
        tag.addGestureRecognizer(gr)
        
        SwapTagStatus(tag)

        return tag
    }
    
    func DrawIllnessPanel(info: [String: AnyObject], prev: UIView?) -> UIView? {
        let panel = UIView()
        
        BodyView.addSubview(panel)
        if(nil == prev) {
            panel.anchorToEdge(Edge.Top, padding: 70.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        } else {
            panel.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 60.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        }
        
        let tagName = YMVar.GetStringByKey(info, key: "name")
        let tagNameLabel = YMLayout.GetNomalLabel(tagName, textColor: YMColors.FontGray, fontSize: 30.LayoutVal()) //BuildTag(tagName)
        let illnessPanel = UIView()
        let dividerLine = UIView()
        dividerLine.backgroundColor = YMColors.DividerLineGray
        
        panel.addSubview(tagNameLabel)
        panel.addSubview(dividerLine)
        panel.addSubview(illnessPanel)
        tagNameLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: tagNameLabel.width, height: tagNameLabel.height)
        dividerLine.align(Align.UnderMatchingLeft, relativeTo: tagNameLabel, padding: 10.LayoutVal(), width: YMSizes.PageWidth - 80.LayoutVal(), height: YMSizes.OnPx)
        illnessPanel.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: tagNameLabel.height + 20.LayoutVal(), width: YMSizes.PageWidth, height: 0)

        let illnessList = info["illness"] as? [[String: AnyObject]]
        if(nil == illnessList) {
            panel.removeFromSuperview()
            return prev
        }
        
        if(0 == illnessList!.count) {
            panel.removeFromSuperview()
            return prev
        }
        
        var listData = [[String: AnyObject]]()
        for illness in illnessList! {
            let illName = YMVar.GetStringByKey(illness, key: "name")
            let illId = YMVar.GetStringByKey(illness, key: "id")
            
            listData.append(["name": illName, "text": illName, "id": illId, "selected": "0"])
        }
        
        let lastLine = YMLayout.DrawTagList(listData, tagPanel: illnessPanel, tagBuilder: TagBuilder,
                                            lineWidth: 670.LayoutVal(), lineHeight: 40.LayoutVal(),
                                            firstLineXPos: 40.LayoutVal(), firstLineYPos: 0, lineSpace: 30.LayoutVal(),
                                            tagSpace: 10.LayoutVal(), tagInnerPadding: 20.LayoutVal())
        
        YMLayout.SetViewHeightByLastSubview(illnessPanel, lastSubView: lastLine)
        YMLayout.SetViewHeightByLastSubview(panel, lastSubView: illnessPanel)
        return panel
    }
    
    func DrawIllnessList(tags: [[String:AnyObject]]) {
        let SelectedTagList = GetIllnessList(tags)
        YMLayout.ClearView(view: BodyView)
        if(0 == SelectedTagList.count) {
            DrawBlankContent()
            return
        }
        
        var prev: UIView? = nil
        for tag in SelectedTagList {
            prev = DrawIllnessPanel(tag, prev: prev)
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev, padding: 128.LayoutVal())
    }
    
    func GetIllnessList(tags: [[String:AnyObject]]) ->  [[String:AnyObject]]{
        let selectedTagList = GetSelectedTagList()
        
        if(0 == selectedTagList.count) {
            return [[String:AnyObject]]()
        }

        var selectedArr = [[String:AnyObject]]()
        for id in selectedTagList {
            for tag in tags {
                let tagId = YMVar.GetStringByKey(tag, key: "id")
                if(id == tagId) {
                    selectedArr.append(tag)
                    break
                }
            }
        }
        
        return selectedArr
    }
}





