//
//  PageShowWebBodyView.swift
//  YiMai
//
//  Created by Wang Huaiyu on 16/10/15.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageShowWebBodyView: PageBodyView, UIWebViewDelegate {
    var WebActions: PageShowWebViewActions!
    var WebPanel = UIWebView()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        WebActions = PageShowWebViewActions(navController: self.NavController,
                                            target: self)
        
        DrawBody()
    }
    
    func DrawBody() {
        BodyView.addSubview(WebPanel)
        WebPanel.fillSuperview()
        WebPanel.delegate = self
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.FullPageLoading.Hide()
    }
    
    func Clear() {
        let url = NSURL(string: "about:blank")
        let req = NSURLRequest(URL: url!)
        
        WebPanel.loadRequest(req)
    }
    
    func LoadWebPage(urlString: String) {
        let url = NSURL(string: urlString)
        let req = NSURLRequest(URL: url!)
        
        self.FullPageLoading.Show()
        WebPanel.loadRequest(req)
    }
}









