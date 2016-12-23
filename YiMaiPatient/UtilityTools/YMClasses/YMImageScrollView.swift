//
//  YMImageScrollView.swift
//  YiMai
//
//  Created by why on 2016/12/18.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class YMImageHScrollView: UIView,UIScrollViewDelegate {
    var ImageViewArr = [YMTouchableImageView]()
    var PageControl: UIPageControl!
    var ScrollView: UIScrollView!
    
    var CurrentPage: Int = 0 {
        didSet {
            PageControl.currentPage = CurrentPage
        }
    }
    var ScrollTimer: NSTimer? = nil
    var ScrollInterval = 0.0
    
    var UserDraggedFlag = false
    
    init(interval: Double = 5.0) {
        super.init(frame: CGRect.zero)
        ScrollInterval = interval
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetImages(images: [YMTouchableImageView]) ->  YMImageHScrollView {
        StopAutoScroll()

        YMLayout.ClearView(view: self)
        ScrollView = UIScrollView()
        PageControl = UIPageControl()
        
        ScrollView.pagingEnabled = true;
        ScrollView.showsVerticalScrollIndicator = false
        ScrollView.delegate = self

        self.addSubview(ScrollView)
        ScrollView.fillSuperview()
        self.addSubview(PageControl)
        PageControl.anchorToEdge(Edge.Bottom, padding: 40.LayoutVal(), width: width, height: 20.LayoutVal())

        ImageViewArr = images
        ScrollView.contentOffset = CGPointMake(0, 0);
        ScrollView.alwaysBounceHorizontal = true
        
        var prevImg: YMTouchableImageView? = nil
        for img in ImageViewArr {
            ScrollView.addSubview(img)
            img.fillSuperview()
            if(nil != prevImg) {
                img.align(Align.ToTheRightCentered, relativeTo: prevImg!, padding: 0, width: img.width, height: img.height)
            }
            prevImg = img
        }
        
        ScrollView.contentSize = CGSizeMake(CGFloat(ImageViewArr.count) * width, height)
        
        PageControl.currentPageIndicatorTintColor = YMColors.White
        PageControl.pageIndicatorTintColor = YMColors.FontLighterGray
        PageControl.currentPage = 0
        PageControl.numberOfPages = ImageViewArr.count;

        return self
    }
    
    func DoScroll() {
        ScrollView.setContentOffset(CGPointMake(width * CGFloat(CurrentPage), 0), animated: true)
    }
    
    func NextImage() {
        let imgCnt = ImageViewArr.count
        if(imgCnt < 2) {
            return
        }
        
        CurrentPage += 1
        
        if(CurrentPage > imgCnt - 1) {
            CurrentPage = 0
        }
        DoScroll()
    }
    
    func PrevImage() {
        let imgCnt = ImageViewArr.count
        if(imgCnt < 2) {
            return
        }
        
        CurrentPage -= 1
        
        if(0 == CurrentPage) {
            CurrentPage = imgCnt - 1
        }
        DoScroll()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        StopAutoScroll()
        UserDraggedFlag = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(UserDraggedFlag) {
            let xOffset = ScrollView.contentOffset.x;
            let page = Int((xOffset + width/2) / width);
            
            if(page >= 0 && page <= (ImageViewArr.count - 1)) {
                CurrentPage = page
            }
            StartAutoScroll()
            UserDraggedFlag = false
            return
        }
    }
    
    func StartAutoScroll() {
        StopAutoScroll()
        ScrollTimer = NSTimer.scheduledTimerWithTimeInterval(ScrollInterval, target: self, selector: "NextImage".Sel(), userInfo: nil, repeats: true)
        let runloop = NSRunLoop.currentRunLoop()
        runloop.addTimer(ScrollTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func StopAutoScroll() {
        ScrollTimer?.invalidate()
        ScrollTimer = nil
    }
}



