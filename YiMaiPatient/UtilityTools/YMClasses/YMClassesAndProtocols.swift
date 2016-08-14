//
//  YMProtocols.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class StoryboardThatExist {
    public static let StoryboardMap: [String:Bool] = [
        YMCommonStrings.CS_PAGE_LOGIN_NAME: true,
        YMCommonStrings.CS_PAGE_INDEX_NAME: true,
        YMCommonStrings.CS_PAGE_REGISTER_NAME: true,
        YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME: true,
        YMCommonStrings.CS_PAGE_SELECT_CITY_NAME: true
    ]
}

public class NoBackByGesturePage {
    public static let PageMap: [String:Bool] = [
        YMCommonStrings.CS_PAGE_LOGIN_NAME: true,
        YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME: true,
        YMCommonStrings.CS_PAGE_INDEX_NAME:true,
        YMCommonStrings.CS_PAGE_PERSONAL_NAME:true,
        YMCommonStrings.CS_PAGE_YIMAI_NAME:true
    ]
}

public protocol PageJumpActionsProtocol {
//    var ControllersDict : Dictionary<String, UIViewController> {get set}
    var NavController : UINavigationController? {get set}
    func PageJumpTo(sender:YMButton)
    func PageJumpToByViewSender(sender : UITapGestureRecognizer)
    func PageJumpToByImageViewSender(sender : UITapGestureRecognizer)
}

public class PageJumpActions: NSObject, PageJumpActionsProtocol{
    public static var ControllersDict : Dictionary<String, UIViewController>? = nil// Dictionary<String, UIViewController>()
    public var NavController : UINavigationController? = nil
    public var JumpWidthAnimate = true
    public var Target: AnyObject? = nil
    
    public static let PageJumToSel: Selector = "PageJumpTo:".Sel()
    public static let PageJumpToByViewSenderSel: Selector = "PageJumpToByViewSender:".Sel()
    public static let PageJumpToByImageViewSenderSel: Selector = "PageJumpToByImageViewSender:".Sel()
    public static let DoNothingSel = "DoNothingActions:".Sel()
    
    convenience init(navController: UINavigationController?) {
        self.init()
        self.NavController = navController
        
        ExtInit()
    }
    
    convenience init(navController: UINavigationController?, target: AnyObject) {
        self.init()
        self.NavController = navController
        self.Target = target
        
        ExtInit()
    }
    
    func ExtInit() {}
    
    public func DoNothingActions(param: AnyObject) {}
    
    public func DoJump(targetPageName: String) {
        var targetPage: UIViewController? = nil
        
        if((StoryboardThatExist.StoryboardMap[targetPageName]) == nil) {
            print("page \(targetPageName) not exist")
            return
        }
        
        if(nil == PageJumpActions.ControllersDict) {
            PageJumpActions.ControllersDict = Dictionary<String, UIViewController>()
        }
        
        if(nil != PageJumpActions.ControllersDict?.indexForKey(targetPageName)){
            targetPage = PageJumpActions.ControllersDict![targetPageName]!
        } else {
            targetPage = YMLayout.GetStoryboardControllerByName(targetPageName)!
            PageJumpActions.ControllersDict?[targetPageName] = targetPage
        }
        
        YMCurrentPage.CurrentPage = targetPageName
        
        var push = true
        for ctrl in self.NavController!.viewControllers {
            if(targetPage == ctrl) {
                push = false
                break
            }
        }

        if(push) {
            self.NavController!.pushViewController(targetPage!, animated: JumpWidthAnimate)
        } else {
            self.NavController!.popToViewController(targetPage!, animated: JumpWidthAnimate)
        }
    }

    public func PageJumpTo(sender:YMButton) {
        if(nil == self.NavController){return}
        let targetPageName = sender.UserStringData
        if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
            DoJump(targetPageName)
        } else {
            print("page \(targetPageName) not exist")
        }
    }
    
    public func PageJumpToByViewSender(sender : UITapGestureRecognizer) {
        if(nil == self.NavController){return}
        
        let targetView = sender.view!
        
        if(targetView.isKindOfClass(YMTouchableView)){
            let touchableView = targetView as! YMTouchableView
            let targetPageName = touchableView.UserStringData
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
    
    public func PageJumpToByImageViewSender(sender : UITapGestureRecognizer) {
        if(nil == self.NavController){return}
        
        let targetView = sender.view!
        
        if(targetView.isKindOfClass(YMTouchableImageView)){
            let touchableView = targetView as! YMTouchableImageView
            let targetPageName = touchableView.UserStringData
            if((StoryboardThatExist.StoryboardMap[targetPageName]) != nil){
                DoJump(targetPageName)
            } else {
                print("page \(targetPageName) not exist")
            }
        }
    }
}

public class PageViewController: UIViewController, UIGestureRecognizerDelegate{
    internal var PageLayoutFlag = false
    internal var TopView : PageCommonTopView? = nil
    internal var BottomView : PageCommonBottomView? = nil
    internal var NavController: UINavigationController? = nil
    internal var SelfView: UIView? = nil

    internal func GestureRecognizerEnable() -> Bool {return true}

    override public func prefersStatusBarHidden() -> Bool {return false}
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.enabled = self.GestureRecognizerEnable()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.PageLayout()
        // Do any additional setup after loading the view.
    }
    
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Do some release operation
        self.PageDisapeared()
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //Do some refresh operations
        self.PageRefresh()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Do some pre-refresh operations
        self.PagePreRefresh()
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)) {
            if(nil == NoBackByGesturePage.PageMap[YMCurrentPage.CurrentPage]) {
                return true
            } else {
                return false
            }
        }

        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func PageLayout() {
        NavController = self.navigationController
        SelfView = self.view
    }
    
    internal func PageDisapeared() {}
    internal func PageRefresh() {
        if(!PageLayoutFlag){PageLayoutFlag = true}
    }
    internal func PagePreRefresh() {}
}

public class PageBodyView {
    internal var ParentView: UIView? = nil
    internal var NavController: UINavigationController? = nil
    internal var Actions: AnyObject? = nil
    public var BodyView: UIScrollView = UIScrollView()
    
    convenience init(parentView: UIView, navController: UINavigationController, pageActions: AnyObject? = nil) {
        self.init()
        self.ParentView = parentView
        self.NavController = navController
        self.Actions = pageActions
        
        self.ViewLayout()
    }
    
    internal func ViewLayout(){
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.PanelBackgroundGray
    }
}















