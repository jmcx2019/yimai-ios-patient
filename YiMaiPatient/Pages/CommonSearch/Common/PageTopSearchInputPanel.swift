//
//  PageSearchTopInputPanel.swift
//  YiMai
//
//  Created by why on 16/6/15.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageTopSearchInputPanel: NSObject {
    public let SearchPanel = UIView()
    private var ParentView: UIView? = nil
    private var SearchInput: YMTextField? = nil
    
    init(parent: UIView) {
        let param = TextFieldCreateParam()
        param.BackgroundImageName = ""
        SearchInput = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 60)
    }
}