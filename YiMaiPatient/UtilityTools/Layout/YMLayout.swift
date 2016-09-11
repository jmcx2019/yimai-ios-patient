//
//  YMCommonLayout.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Toucan
import ChameleonFramework
import Photos

public class TextFieldCreateParam {
    public var Placholder : String = ""
    public var DefaultText : String = ""
    public var Frame : CGRect = CGRect()
    public var BackgroundColor : UIColor = UIColor.whiteColor()
    public var FontSize : CGFloat = 12.0
    public var FontColor : UIColor = UIColor.blackColor()
    public var BackgroundImageName : String = ""
    public var BackgroundImage : UIImage? = nil
}

public class TextFieldPaddingParam {
    public var LeftPadding : UIView? = nil
    public var RightPadding : UIView? = nil
}

public class YMLayout {
    public static let TextFieldDelegate = YMTextFieldDelegate()

    public static func GetSuitableImageView(imageName: String) -> YMTouchableImageView {
        let suitableImageView = YMTouchableImageView(image: UIImage(named:imageName))
        
        suitableImageView.frame = CGRect(x: 0, y: 0, width: suitableImageView.width.LayoutImgVal(), height: suitableImageView.height.LayoutImgVal())
        return suitableImageView
    }
    
    public static func GetSuitableImageView(image: UIImage) -> YMTouchableImageView {
        let suitableImageView = YMTouchableImageView(image: image)
        
        suitableImageView.frame = CGRect(x: 0, y: 0, width: suitableImageView.width.LayoutImgVal(), height: suitableImageView.height.LayoutImgVal())
        return suitableImageView
    }
    
    public static func GetTouchableImageView(useObject actionTarget: AnyObject, useMethod actionFunc: Selector, imageName: String) -> YMTouchableImageView{
        let newImageView = YMLayout.GetSuitableImageView(imageName)
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)
        
        newImageView.userInteractionEnabled = true
        newImageView.addGestureRecognizer(tapGR)
        
        return newImageView
    }
    
    public static func GetTouchableImageView(useObject actionTarget: AnyObject, useMethod actionFunc: Selector, image: UIImage) -> YMTouchableImageView{
        let newImageView = YMLayout.GetSuitableImageView(image)
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)
        
        newImageView.userInteractionEnabled = true
        newImageView.addGestureRecognizer(tapGR)
        
        return newImageView
    }
    
    public static func GetTouchableView(useObject actionTarget: AnyObject, useMethod actionFunc: Selector, userStringData: String = "") -> YMTouchableView {
        let newView = YMTouchableView()

        newView.UserStringData = userStringData
        let tapGR = UITapGestureRecognizer(target: actionTarget, action: actionFunc)

        newView.userInteractionEnabled = true
        newView.addGestureRecognizer(tapGR)
        newView.backgroundColor = YMColors.White

        return newView
    }
    
    public static func GetTextField(param: TextFieldCreateParam) -> YMTextField {
        let newTextField = YMTextField(aDelegate: nil)

        newTextField.placeholder = param.Placholder
        newTextField.font = UIFont.systemFontOfSize(param.FontSize)
        newTextField.textColor = param.FontColor
        newTextField.delegate = YMLayout.TextFieldDelegate
        newTextField.text = ""
        
        if(nil != param.BackgroundImage) {
            newTextField.background = param.BackgroundImage
        } else if ("" != param.BackgroundImageName) {
            newTextField.background = UIImage(named: param.BackgroundImageName)
        } else {
            newTextField.backgroundColor = param.BackgroundColor
        }
        
        return newTextField
    }
    
    public static func GetTextFieldWithMaxCharCount(createParam: TextFieldCreateParam, maxCharCount: Int) -> YMTextField {
        let textField = YMLayout.GetTextField(createParam)
        textField.MaxCharCount = maxCharCount
        
        return textField
    }
    
    public static func GetCellPhoneField(param: TextFieldCreateParam) -> YMTextField {
        let newTextField = YMLayout.GetTextFieldWithMaxCharCount(param, maxCharCount: 13)
        newTextField.keyboardType = UIKeyboardType.NumberPad

        return newTextField
    }
    
    public static func GetPasswordField(createParam: TextFieldCreateParam) ->  YMTextField {
        let textField = YMLayout.GetTextField(createParam)
        textField.secureTextEntry = true
        return textField
    }
    
    public static func GetPasswordFieldWithMaxCharCount(createParam: TextFieldCreateParam, maxCharCount: Int) ->  YMTextField {
        let textField = YMLayout.GetPasswordField(createParam)
        textField.MaxCharCount = maxCharCount
        return textField
    }
    
    public static func GetStoryboardControllerByName(storyboardName: String) -> UIViewController? {
        let newStroyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return newStroyboard.instantiateInitialViewController()
    }
    
    public static func BodyLayoutWithTop(parentView: UIView, bodyView: UIScrollView) {
        parentView.addSubview(bodyView)
        bodyView.backgroundColor = YMColors.BackgroundGray
        bodyView.fillSuperview()
        bodyView.contentInset = YMSizes.PageScrollBodyInsetOnlyTop
    }
    
    public static func BodyLayoutWithTopAndBottom(parentView: UIView, bodyView: UIScrollView) {
        parentView.addSubview(bodyView)
        bodyView.backgroundColor = YMColors.BackgroundGray
        bodyView.fillSuperview()
        bodyView.contentInset = YMSizes.PageScrollBodyInset
    }
    
    public static func DrawGrayVerticalSpace(parentView: UIView, height: CGFloat, relativeTo: UIView? = nil) -> UIView {
        let spaceView = UIView()
        spaceView.backgroundColor = YMColors.BackgroundGray
        
        parentView.addSubview(spaceView)
        if(nil != relativeTo){
            spaceView.align(Align.UnderMatchingLeft, relativeTo: relativeTo!, padding: 0, width: parentView.width, height: height)
        } else {
            spaceView.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: height)
        }
        
        return spaceView
    }
    
    public static func ClearView(view target: UIView) {
        for view in target.subviews{
            let v = view as? YMTouchableView
            v?.UserObjectData = nil
            v?.UserStringData = ""
            view.removeFromSuperview()
        }
    }
    
    public static func SetViewHeightByLastSubview(view: UIView, lastSubView: UIView, bottomPadding: CGFloat = 0) {
        let viewPoint = view.frame.origin
        view.frame = CGRectMake(viewPoint.x, viewPoint.y, view.width,
                                lastSubView.height + lastSubView.frame.origin.y + bottomPadding)
    }
    
    public static func SetHScrollViewContentSize(scrollView: UIScrollView, lastSubView: UIView?, padding: CGFloat = 0) {
        if(nil == lastSubView) { return }
        scrollView.contentSize = CGSizeMake(lastSubView!.width + lastSubView!.frame.origin.x + padding,
                                            scrollView.height)
    }
    
    public static func SetVScrollViewContentSize(scrollView: UIScrollView, lastSubView: UIView?, padding: CGFloat = 0) {
        if(nil == lastSubView) { return }
        scrollView.contentSize = CGSizeMake(scrollView.width,
                                            lastSubView!.height + lastSubView!.frame.origin.y + padding)
    }

    public static func GetCommonFullWidthTouchableView(
        parentView: UIView,
        useObject: AnyObject,
        useMethod: Selector,
        label: UILabel,
        text: String,
        userStringData: String = "",
        fontSize: CGFloat = 28.LayoutVal(),
        showArrow: Bool = true) -> YMTouchableView {
        
        let view = YMLayout.GetTouchableView(useObject: useObject, useMethod: useMethod, userStringData: userStringData)
        let borderBottom = UIView()
        
        borderBottom.backgroundColor = YMColors.CommonBottomGray
        
        label.text = text
        label.font = YMFonts.YMDefaultFont(fontSize)
        label.textColor = YMColors.FontGray
        label.sizeToFit()
        
        parentView.addSubview(view)
        view.addSubview(label)
        view.addSubview(borderBottom)
        
        view.frame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: YMSizes.CommonTouchableViewHeight)
        label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 650.LayoutVal(), height: label.height)
        borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        if(showArrow) {
            let arrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
            view.addSubview(arrow)
            arrow.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrow.width, height: arrow.height)
        }
        
        return view
    }
    
    public static func GetCommonLargeFullWidthTouchableView(
        parentView: UIView,
        useObject: AnyObject,
        useMethod: Selector,
        label: UILabel,
        text: String,
        userStringData: String = "",
        fontSize: CGFloat = 28.LayoutVal(),
        showArrow: Bool = true) -> YMTouchableView {
            
            let view = YMLayout.GetTouchableView(useObject: useObject, useMethod: useMethod, userStringData: userStringData)
            let borderBottom = UIView()
            
            borderBottom.backgroundColor = YMColors.CommonBottomGray
            
            label.text = text
            label.font = YMFonts.YMDefaultFont(fontSize)
            label.textColor = YMColors.FontGray
            label.sizeToFit()
            
            parentView.addSubview(view)
            view.addSubview(label)
            view.addSubview(borderBottom)
            
            view.frame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth, height: YMSizes.CommonLargeTouchableViewHeight)
            label.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 650.LayoutVal(), height: label.height)
            borderBottom.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
            
            if(showArrow) {
                let arrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
                view.addSubview(arrow)
                arrow.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrow.width, height: arrow.height)
            }
            
            return view
    }
    
    public static func GetCommonUserHeadImage(url: String, useObject: AnyObject? = nil, useMethod: Selector? = nil) -> YMTouchableImageView {
        var userHead: YMTouchableImageView? = nil
        if(nil == useObject){
            userHead = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        } else {
            userHead = YMLayout.GetTouchableImageView(useObject: useObject!, useMethod: useMethod!, imageName: "CommonHeadImageBorder")
        }
        
        let fullUrlString = YMAPIInterfaceURL.Server + url
        let urlObj = NSURL(string: fullUrlString)
        
        userHead!.setImageWithURL(urlObj!)
        
        return userHead!
    }
    
    public static func LoadImageFromServer(imageView: UIImageView, url: String, fullUrl: String? = nil, makeItRound: Bool = false) {
        var url = url
        
        if(nil != fullUrl) {
            url = fullUrl!
        } else {
            url = YMAPIInterfaceURL.Server + url
        }
        
        imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: imageView.image, optionsInfo: nil, progressBlock: nil,  completionHandler: { (image, error, cacheType, imageURL) in
            if(makeItRound) {
                imageView.image = Toucan(image: image!).maskWithEllipse().image
            }
        })
    }
    
    public static func DrawCommonDocCell(data: [String: AnyObject], docPanel: UIView, action: AnyObject, selector: Selector, prevCell: UIView?) -> YMTouchableView {
        let head = data["head_url"] as! String
        let name = data["name"] as! String
        let hospital = data["hospital"] as! [String: AnyObject]
        let department = data["department"] as! [String: AnyObject]
        let jobTitle = data["job_title"] as? String
        let userId = data["id"] as! String
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let userHeadBackground = YMLayout.GetSuitableImageView("HeadImageBorder")
        let bottomBorder = UIView()
        
        bottomBorder.backgroundColor = HexColor("#e0e0e0")
        
        YMLayout.LoadImageFromServer(userHeadBackground, url: head)
        nameLabel.text = name
        nameLabel.textColor = YMColors.PatientFontGray
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.PatientFontGray
        
        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.PatientFontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = department["name"] as? String
        deptLabel.textColor = YMColors.PatientFontGray
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = hospital["name"] as? String
        hosLabel.textColor = YMColors.PatientFontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        let cell = YMLayout.GetTouchableView(useObject: action, useMethod: selector, userStringData: userId)
        
        cell.addSubview(userHeadBackground)
        cell.addSubview(nameLabel)
        cell.addSubview(divider)
        cell.addSubview(jobTitleLabel)
        cell.addSubview(deptLabel)
        cell.addSubview(hosLabel)
        cell.addSubview(bottomBorder)
        
        cell.UserObjectData = data
        
        docPanel.addSubview(cell)
        
        if(nil == prevCell) {
            cell.anchorToEdge(Edge.Top, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 150.LayoutVal())
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevCell!, padding: YMSizes.OnPx, height: 150.LayoutVal())
        }
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
        bottomBorder.anchorToEdge(Edge.Bottom, padding: 0, width: cell.width, height: YMSizes.OnPx)
        
        return cell
    }
    
    public static func GetNomalLabel(text: String, textColor: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = YMFonts.YMDefaultFont(fontSize)
        label.sizeToFit()

        return label
    }

    public static func TransPHAssetToUIImage(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var img = UIImage()
        option.synchronous = true
        let targetWidth = asset.pixelWidth.LayoutVal()
        let targetHeight = asset.pixelHeight.LayoutVal()
        
        manager.requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                     contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
                                        img = Toucan(image: result!).resize(CGSize(width: targetWidth, height: targetHeight)).image
        })
        
        return img
    }
    
    public static func TransPHAssetsToUIImages(assets: [PHAsset]) -> [UIImage] {
        var ret = [UIImage]()
        
        for asset in assets {
            ret.append(YMLayout.TransPHAssetToUIImage(asset))
        }
        return ret
    }
}



























