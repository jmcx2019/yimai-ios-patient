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
    var AllTags = [YMTouchableView]()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        DeptActions = PageSelectFocusedDeptActions(navController: NavController!, target: self)
    }

    func TagBuilder(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView {
        let tag = YMLayout.GetTouchableView(useObject: DeptActions, useMethod: "TagTouched:".Sel())
        tag.backgroundColor = YMColors.PatientFontGreen
        
        let tagLabel = YMLayout.GetNomalLabel(tagText, textColor: YMColors.White, fontSize: 26.LayoutVal())
        tag.frame = CGRect(x: 0,y: 0,width: tagInnerPadding*2 + tagLabel.width,height: tagHeight)
        tag.addSubview(tagLabel)
        
        tagLabel.anchorInCenter(width: tagLabel.width, height: tagLabel.height)
        tag.layer.borderColor = YMColors.PatientFontGreen.CGColor
        tag.layer.borderWidth = 2.LayoutVal()
        tag.layer.masksToBounds = true
        tag.layer.cornerRadius = 10.LayoutVal()

        tag.UserObjectData = ["label": tagLabel, "text":tagText, "status": "selected"]
        
        AllTags.append(tag)
        return tag
    }

    func LoadData(data: [[String: AnyObject]]) {
        
        var tagList = [[String: AnyObject]]()
        for tag in data {
            let newTag = ["text": tag["name"] as! String, "id": "\(tag["id"])", "illness": tag["illness"]!]
            tagList.append(newTag)
        }
        
        YMLayout.DrawTagList(tagList, tagPanel: BodyView, tagBuilder: TagBuilder, lineWidth: 670.LayoutVal(), lineHeight: 40.LayoutVal(),
                             firstLineXPos: 40.LayoutVal(), firstLineYPos: 0, lineSpace: 30.LayoutVal(),
                             tagSpace: 10.LayoutVal(), tagInnerPadding: 20.LayoutVal())
        
//        for dept in data {
//            YMLayout.DrawTagList(<#T##tags: NSArray##NSArray#>, tagPanel: <#T##UIView#>, tagBuilder: <#T##TagBuilderCB##TagBuilderCB##(tagText: String, tagInnerPadding: CGFloat, tagHeight: CGFloat, userData: AnyObject) -> UIView#>, lineWidth: <#T##CGFloat#>, lineHeight: <#T##CGFloat#>, firstLineXPos: <#T##CGFloat#>, firstLineYPos: <#T##CGFloat#>, lineSpace: <#T##CGFloat#>, tagSpace: <#T##CGFloat#>, tagInnerPadding: <#T##CGFloat#>, lineJustified: <#T##Bool#>, maxTagsInLine: <#T##Int#>)
//        }
    }
}



