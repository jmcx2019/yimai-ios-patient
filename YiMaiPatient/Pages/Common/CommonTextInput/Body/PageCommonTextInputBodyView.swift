//
//  PageCommonTextInputBodyView.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/9/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageCommonTextInputBodyView: PageBodyView {
    var TextInput: YMTextField!
    
    override func ViewLayout() {
        super.ViewLayout()
    }

    func DrawTextInput() {
        YMLayout.ClearView(view: BodyView)
        let param = TextFieldCreateParam()
        
        param.Placholder = PageCommonTextInputViewController.Placeholder
        param.FontSize = 32.LayoutVal()
        param.FontColor = YMColors.FontGray

        if(PageCommonTextInputType.Text == PageCommonTextInputViewController.InputType) {
            TextInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: PageCommonTextInputViewController.InputMaxLen)
        } else {
            TextInput = YMLayout.GetCellPhoneField(param)
        }
        
        TextInput.SetBothPaddingWidth(40.LayoutVal())
        
        BodyView.addSubview(TextInput)
        TextInput.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 70.LayoutVal(),
                                    otherSize: 60.LayoutVal())
    }
}





