//
//  PageWalletRecord.swift
//  YiMaiPatient
//
//  Created by why on 2016/12/15.
//  Copyright © 2016年 yimai. All rights reserved.
//

import Foundation
import UIKit

class PageWalletRecordViewController: PageViewController {
    var BodyView: PageWalletRecordBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageWalletRecordBodyView(parentView: self.view, navController: NavController!)
        TopView = PageCommonTopView(parentView: self.view, titleString: "明细", navController: NavController!)
    }
    
    override func PagePreRefresh() {
        BodyView.FullPageLoading.Show()
        BodyView.ListActions.ListApi.YMGetWalletRecord()
    }
}



