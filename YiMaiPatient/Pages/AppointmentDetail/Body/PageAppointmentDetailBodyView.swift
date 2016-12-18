//
//  PageAppointmentDetailBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/25.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import Toucan

public class PageAppointmentDetailBodyView: PageBodyView {
    private let Breadcrumbs = YMTouchableView()
    private let DPPanel = UIView()
    private let DocCell = UIView()
    private let ProxyDocCell = UIView()
    private let DocOnlyCell = UIView()
    private let PlatformCell = UIView()
    private let PatientCell = UIView()
    private let AppointmentNum = UILabel()
    private let TextInfoPanel = UIView()
    private let ImagePanel = UIView()
    private let TimeLinePanel = UIView()
    
    private let DPDivider = UIView()
    
    private var TimelineIconMap = [String: String]()
    
    private var DetailActions: PageAppointmentDetailActions? = nil
    
    var GoToPayBtn = YMButton()
    var ConfirmBtn = YMButton()
    var ImageList = [UIImageView]()

    public var Loading: YMPageLoadingView? = nil

    override func ViewLayout() {
        super.ViewLayout()
        
        DetailActions = PageAppointmentDetailActions(navController: self.NavController!, target: self)
//        Loading = YMPageLoadingView(parentView: self.BodyView)
        
        CreateTimelineIconMap()
        DrawBreadcrumbs()
        DrawDP()
        DrawAppointmentNum()
        FullPageLoading?.Show()
    }
    
    private func CreateTimelineIconMap() {
        TimelineIconMap["begin"] = "YMIconTimelineBegin"
        TimelineIconMap["close"] = "YMIconTimelineClose"
        TimelineIconMap["completed"] = "YMIconTimelineCompleted"
        TimelineIconMap["no"] = "YMIconTimelineCancel"
        TimelineIconMap["notepad"] = "YMIconTimelineNotepadBlue"
        TimelineIconMap["lastNotepad"] = "YMIconTimelineNotepadYellow"
        TimelineIconMap["pass"] = "YMIconTimelinePass"
        TimelineIconMap["time"] = "YMIconTimelineTime"
        TimelineIconMap["wait"] = "YMIconTimelineWait"
    }
    
    private func DrawBreadcrumbs() {
        BodyView.addSubview(Breadcrumbs)
        Breadcrumbs.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 110.LayoutVal())
        
        func InitLabels(label: UILabel, text: String) {
            label.text = text
            label.textColor = YMColors.FontGray
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = YMColors.CommonBottomGray
            label.font = YMFonts.YMDefaultFont(24.LayoutVal())
            label.layer.cornerRadius = 8.LayoutVal()
            label.layer.masksToBounds = true
        }
        
        let start = UILabel()
        let patientConfirm = UILabel()
        let docConfirm = UILabel()
        let end = UILabel()
        let indc = UILabel()
        
        let arr1 = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        let arr2 = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        let arr3 = YMLayout.GetSuitableImageView("CommonGrayRightArrowIcon")
        
        Breadcrumbs.addSubview(start)
        Breadcrumbs.addSubview(patientConfirm)
        Breadcrumbs.addSubview(docConfirm)
        Breadcrumbs.addSubview(end)
        Breadcrumbs.addSubview(indc)

        Breadcrumbs.addSubview(arr1)
        Breadcrumbs.addSubview(arr2)
        Breadcrumbs.addSubview(arr3)
        
        InitLabels(start, text: "发起约诊")
        InitLabels(patientConfirm, text: "患者确认")
        InitLabels(docConfirm, text: "医生确认")
        InitLabels(end, text: "面诊完成")
        
        let labelWidth = 140.LayoutVal()
        let labelHeight = 40.LayoutVal()
        let labelPadding = 44.LayoutVal()
        let arrPadding = (labelPadding - arr1.width) / 2
        start.anchorInCorner(Corner.TopLeft, xPad: 30.LayoutVal(), yPad: 20.LayoutVal(),
                             width: labelWidth, height: labelHeight)
        
        patientConfirm.align(Align.ToTheRightCentered, relativeTo: start,
                             padding: labelPadding, width: labelWidth, height: labelHeight)
        
        docConfirm.align(Align.ToTheRightCentered, relativeTo: patientConfirm,
                             padding: labelPadding, width: labelWidth, height: labelHeight)

        
        end.align(Align.ToTheRightCentered, relativeTo: docConfirm,
                             padding: labelPadding, width: labelWidth, height: labelHeight)
        
        arr1.alignBetweenHorizontal(align: Align.ToTheRightCentered,
                                    primaryView: start, secondaryView: patientConfirm,
                                    padding: arrPadding, height: arr1.height)
        
        arr2.alignBetweenHorizontal(align: Align.ToTheRightCentered,
                                    primaryView: patientConfirm, secondaryView: docConfirm,
                                    padding: arrPadding, height: arr1.height)
        
        arr3.alignBetweenHorizontal(align: Align.ToTheRightCentered,
                                    primaryView: docConfirm, secondaryView: end,
                                    padding: arrPadding, height: arr1.height)
        
        indc.textColor = YMColors.FontGray
        indc.font = YMFonts.YMDefaultFont(20.LayoutVal())
        
        Breadcrumbs.UserObjectData = [
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_START: start,
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_PATIENT_CONFIRM: patientConfirm,
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_DOC_CONFIRM: docConfirm,
            YMAppointmentDetailStrings.BREADCRUMBS_LABEL_END: end,

            YMAppointmentDetailStrings.BREADCRUMBS_INDC: indc,

            YMAppointmentDetailStrings.BREADCRUMBS_ARR_1: arr1,
            YMAppointmentDetailStrings.BREADCRUMBS_ARR_2: arr2,
            YMAppointmentDetailStrings.BREADCRUMBS_ARR_3: arr3
        ]
    }

    private func DrawDorctor(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("HeadImageBorder")
        let docName = UILabel()
        let jobTitle = UILabel()
        let dept = UILabel()
        let hospital = UILabel()
        let divider = UIView()
        
        DocCell.addSubview(headImage)
        DocCell.addSubview(jobTitle)
        DocCell.addSubview(docName)
        DocCell.addSubview(dept)
        DocCell.addSubview(hospital)
        DocCell.addSubview(divider)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        let head = data["head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }

        divider.backgroundColor = YMColors.PatientFontGreen
        divider.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 20.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        docName.text = data["name"] as? String
        docName.textColor = YMColors.PatientFontGreen
        docName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        docName.sizeToFit()
        docName.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: docName.width, height: docName.height)
        
        jobTitle.text = "面诊医生"
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: jobTitle.width, height: jobTitle.height)
        
        dept.text = data["department"] as? String
        dept.textColor = YMColors.PatientFontGreen
        dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
        dept.sizeToFit()
        dept.align(Align.UnderCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: dept.width, height: dept.height)
        
        hospital.text = data["hospital"] as? String
        hospital.textColor = YMColors.FontLightGray
        hospital.font = YMFonts.YMDefaultFont(24.LayoutVal())
        hospital.numberOfLines = 2
        hospital.textAlignment = NSTextAlignment.Center
        hospital.frame = CGRectMake(0, 0, 285.LayoutVal(), 0)
        hospital.sizeToFit()
        hospital.align(Align.UnderCentered,
                       relativeTo: dept,
                       padding: 8.LayoutVal(),
                       width: hospital.width, height: hospital.height)
    }
    
    private func DrawProxyDorctor(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("HeadImageBorder")
        let docName = UILabel()
        let jobTitle = UILabel()
        let dept = UILabel()
        let hospital = UILabel()
        let divider = UIView()
        
        ProxyDocCell.addSubview(headImage)
        ProxyDocCell.addSubview(jobTitle)
        ProxyDocCell.addSubview(docName)
        ProxyDocCell.addSubview(dept)
        ProxyDocCell.addSubview(hospital)
        ProxyDocCell.addSubview(divider)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        let head = data["head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        divider.backgroundColor = YMColors.PatientFontGreen
        divider.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 20.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        docName.text = data["name"] as? String
        docName.textColor = YMColors.PatientFontGreen
        docName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        docName.sizeToFit()
        docName.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: docName.width, height: docName.height)
        
        jobTitle.text = "代约医生"
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: jobTitle.width, height: jobTitle.height)
        
        dept.text = data["department"] as? String
        dept.textColor = YMColors.PatientFontGreen
        dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
        dept.sizeToFit()
        dept.align(Align.UnderCentered, relativeTo: divider,
                   padding: 12.LayoutVal(),
                   width: dept.width, height: dept.height)
        
        hospital.text = data["hospital"] as? String
        hospital.textColor = YMColors.FontLightGray
        hospital.font = YMFonts.YMDefaultFont(24.LayoutVal())
        hospital.numberOfLines = 2
        hospital.textAlignment = NSTextAlignment.Center
        hospital.frame = CGRectMake(0, 0, 285.LayoutVal(), 0)
        hospital.sizeToFit()
        hospital.align(Align.UnderCentered,
                       relativeTo: dept,
                       padding: 8.LayoutVal(),
                       width: hospital.width, height: hospital.height)
    }
    
    private func DrawDocOnlyPanel(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("HeadImageBorder")
        let docName = UILabel()
        let jobTitle = UILabel()
        let dept = UILabel()
        let hospital = UILabel()
        let divider = UIView()
        
        DocOnlyCell.addSubview(headImage)
        DocOnlyCell.addSubview(jobTitle)
        DocOnlyCell.addSubview(docName)
        DocOnlyCell.addSubview(dept)
        DocOnlyCell.addSubview(hospital)
        DocOnlyCell.addSubview(divider)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        let head = data["head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        divider.backgroundColor = YMColors.PatientFontGreen
        divider.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 20.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        docName.text = data["name"] as? String
        docName.textColor = YMColors.PatientFontGreen
        docName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        docName.sizeToFit()
        docName.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: docName.width, height: docName.height)
        
        jobTitle.text = "面诊医生"
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: jobTitle.width, height: jobTitle.height)
        
        dept.text = data["department"] as? String
        dept.textColor = YMColors.PatientFontGreen
        dept.font = YMFonts.YMDefaultFont(20.LayoutVal())
        dept.sizeToFit()
        dept.align(Align.UnderCentered, relativeTo: divider,
                   padding: 12.LayoutVal(),
                   width: dept.width, height: dept.height)
        
        hospital.text = data["hospital"] as? String
        hospital.textColor = YMColors.FontLightGray
        hospital.font = YMFonts.YMDefaultFont(24.LayoutVal())
        hospital.numberOfLines = 2
        hospital.textAlignment = NSTextAlignment.Center
        hospital.frame = CGRectMake(0, 0, 285.LayoutVal(), 0)
        hospital.sizeToFit()
        hospital.align(Align.UnderCentered,
                       relativeTo: dept,
                       padding: 8.LayoutVal(),
                       width: hospital.width, height: hospital.height)
    }
    
    private func DrawPlatformPanel() {
        let headImage = YMLayout.GetSuitableImageView("HeadImageBorder")
        let docName = UILabel()
        let jobTitle = UILabel()
        let divider = UIView()
        
        PlatformCell.addSubview(headImage)
        PlatformCell.addSubview(jobTitle)
        PlatformCell.addSubview(docName)
        PlatformCell.addSubview(divider)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        divider.backgroundColor = YMColors.PatientFontGreen
        divider.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 20.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        docName.text = "医者脉连"
        docName.textColor = YMColors.PatientFontGreen
        docName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        docName.sizeToFit()
        docName.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: docName.width, height: docName.height)
        
        jobTitle.text = "平台代约"
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
                       padding: 12.LayoutVal(),
                       width: jobTitle.width, height: jobTitle.height)
    }
    
    private func DrawPatient(data: [String: AnyObject]) {
        let headImage = YMLayout.GetSuitableImageView("HeadImageBorder")
        let patientName = UILabel()
        let gender = UILabel()
        let age = UILabel()
        let phone = UILabel()
        let divider = UIView()
        let phoneIcon = YMLayout.GetSuitableImageView("YMIconPhone")
        
        PatientCell.addSubview(headImage)
        PatientCell.addSubview(patientName)
        PatientCell.addSubview(gender)
        PatientCell.addSubview(age)
        PatientCell.addSubview(phone)
        PatientCell.addSubview(divider)
        PatientCell.addSubview(phoneIcon)
        
        headImage.anchorToEdge(Edge.Top, padding: 30.LayoutVal(),
                               width: headImage.width, height: headImage.height)
        
        let head = data["head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        patientName.text = "\(data["name"]!)"
        patientName.textColor = YMColors.PatientFontGreen
        patientName.font = YMFonts.YMDefaultFont(30.LayoutVal())
        patientName.sizeToFit()
        patientName.align(Align.UnderCentered, relativeTo: headImage,
                      padding: 12.LayoutVal(),
                      width: patientName.width, height: patientName.height)
        
        divider.backgroundColor = YMColors.PatientFontGreen
        divider.align(Align.UnderCentered, relativeTo: patientName,
                      padding: 12.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        
        let genderMap = ["0":"女", "1":"男"]
        gender.text = genderMap["\(data["sex"]!)"]
        gender.textColor = YMColors.FontGray
        gender.font = YMFonts.YMDefaultFont(20.LayoutVal())
        gender.sizeToFit()
        gender.align(Align.ToTheLeftCentered, relativeTo: divider,
                      padding: 12.LayoutVal(),
                      width: gender.width, height: gender.height)
        
        
        
        age.text = "\(data["age"]!) 岁"
        age.textColor = YMColors.FontGray
        age.font = YMFonts.YMDefaultFont(20.LayoutVal())
        age.sizeToFit()
        age.align(Align.ToTheRightCentered, relativeTo: divider,
                     padding: 12.LayoutVal(),
                     width: age.width, height: age.height)
        
        phone.text = data["phone"] as? String
        phone.textColor = YMColors.FontLightGray
        phone.font = YMFonts.YMDefaultFont(20.LayoutVal())
        phone.sizeToFit()
        phone.align(Align.UnderCentered, relativeTo: headImage,
                    padding: 92.LayoutVal(),
                    width: phone.width, height: phone.height)
        
        phoneIcon.align(Align.ToTheLeftCentered, relativeTo: phone,
                        padding: 8.LayoutVal(),
                        width: phoneIcon.width, height: phoneIcon.height)
    }
    
    private func DrawDP() {
        BodyView.addSubview(DPPanel)
        DPPanel.align(Align.UnderMatchingLeft, relativeTo: Breadcrumbs,
                      padding: 0, width: YMSizes.PageWidth, height: 310.LayoutVal())
        
        DocCell.backgroundColor = YMColors.White
        DocOnlyCell.backgroundColor = YMColors.White
        ProxyDocCell.backgroundColor = YMColors.White
        PlatformCell.backgroundColor = YMColors.White
//        PatientCell.backgroundColor = YMColors.White

        DPPanel.addSubview(DocCell)
        DPPanel.addSubview(ProxyDocCell)
        DPPanel.addSubview(DPDivider)
        DPPanel.addSubview(DocOnlyCell)
        DPPanel.addSubview(PlatformCell)
//        DPPanel.addSubview(PatientCell)
        DPPanel.groupAndFill(group: Group.Horizontal, views: [ProxyDocCell, DocCell], padding: 0)
        DocOnlyCell.fillSuperview()
        PlatformCell.fillSuperview()
        DPDivider.backgroundColor = YMColors.DividerLineGray
        DPDivider.anchorInCenter(width: YMSizes.OnPx, height: DPPanel.height)
    }
    
    private func DrawAppointmentNum() {
        BodyView.addSubview(AppointmentNum)
        AppointmentNum.font = YMFonts.YMDefaultFont(20.LayoutVal())
        AppointmentNum.textColor = YMColors.PatientFontGreen
        AppointmentNum.textAlignment = NSTextAlignment.Center
        AppointmentNum.align(Align.UnderMatchingLeft, relativeTo: DPPanel,
                             padding: 0, width: YMSizes.PageWidth, height: 50.LayoutVal())
    }
    
    private func DrawTextInfo(data: [String: AnyObject]) {
        BodyView.addSubview(TextInfoPanel)
        TextInfoPanel.backgroundColor = YMColors.White
        TextInfoPanel.align(Align.UnderMatchingLeft, relativeTo: AppointmentNum,
                            padding: 0, width: YMSizes.PageWidth, height: 220.LayoutVal())
        
        let titleLabel = UILabel()
        var history = data["history"] as? String
        
        TextInfoPanel.addSubview(titleLabel)
        titleLabel.text = "病情资料"
        titleLabel.textColor = YMColors.PatientFontGreen
        titleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        titleLabel.sizeToFit()
        titleLabel.anchorInCorner(Corner.TopLeft,
                                  xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
                                  width: titleLabel.width, height: titleLabel.height)

        if(YMValueValidator.IsEmptyString(history)) {
            history = "无"
        }

        let textContent = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "TextDetailTouched:".Sel())
        TextInfoPanel.addSubview(textContent)
        
        let divider = UIView()
        divider.backgroundColor = YMColors.DividerLineGray
        TextInfoPanel.addSubview(divider)
        divider.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 60.LayoutVal(), width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        let hisLabel = UILabel()
        hisLabel.numberOfLines = 3
        hisLabel.text = history!
        hisLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hisLabel.textColor = YMColors.FontGray
        hisLabel.frame = CGRectMake(0, 0, 670.LayoutVal(), 0)
        hisLabel.sizeToFit()
        textContent.align(Align.UnderMatchingLeft, relativeTo: divider,
                          padding: 30.LayoutVal(),
                          width: YMSizes.PageWidth,
                          height: hisLabel.height + 30.LayoutVal())
        textContent.addSubview(hisLabel)
        hisLabel.anchorToEdge(Edge.Top, padding: 0, width: hisLabel.width, height: hisLabel.height)
        hisLabel.anchorInCorner(Corner.TopLeft,
                                xPad: 40.LayoutVal(), yPad: 0, width: hisLabel.width, height: hisLabel.height)
    }
    
    public func ShowImage(list: UIScrollView, imgUrl: String, prev: UIImageView?) -> YMTouchableImageView {
        let img = YMTouchableImageView()
        let url = NSURL(string: imgUrl)
//        img.setImageWithURL(url!, placeholderImage: nil)
        
        img.backgroundColor = YMColors.DividerLineGray
        
        list.addSubview(img)
        if(nil == prev) {
            img.anchorToEdge(Edge.Left, padding: 0, width: list.height, height: list.height)
        } else {
            img.align(Align.ToTheRightCentered, relativeTo: prev!,
                      padding: 20.LayoutVal(),
                      width: list.height, height: list.height)
        }
        
        img.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil,  completionHandler: { (image, error, cacheType, imageURL) in
            if(nil != image) {
                img.image = Toucan(image: image!)
                    .resize(CGSize(width: img.width, height: img.height), fitMode: Toucan.Resize.FitMode.Crop).image
            }
        })
        
        let tapGR = UITapGestureRecognizer(target: DetailActions, action: "ImageTouched:".Sel())
        
        img.userInteractionEnabled = true
        img.addGestureRecognizer(tapGR)
        img.UserStringData = "\(ImageList.count)"
        ImageList.append(img)
        return img
    }
    
    private func DrawImageList(data: [String: AnyObject]) {
        ImageList.removeAll()
        BodyView.addSubview(ImagePanel)
        ImagePanel.backgroundColor = YMColors.White
        ImagePanel.align(Align.UnderMatchingLeft, relativeTo: TextInfoPanel,
                         padding: YMSizes.OnPx,
                         width: YMSizes.PageWidth, height: 225.LayoutVal())
        let imgUrlList = data["img_url"] as? String
        if(YMValueValidator.IsEmptyString(imgUrlList)) {
            let noImageLabel = UILabel()
            ImagePanel.addSubview(noImageLabel)
            noImageLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
            noImageLabel.textColor = YMColors.FontGray
            noImageLabel.text = "未提供病历图片"
            noImageLabel.sizeToFit()
            noImageLabel.anchorInCenter(width: noImageLabel.width, height: noImageLabel.height)
            return
        }
        
        let leftArr = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollLeft")
        let rightArr = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollRight")
        let leftButton = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "ImageScrollLeft:".Sel())
        let rightButton = YMLayout.GetTouchableView(useObject: DetailActions!, useMethod: "ImageScrollRight:".Sel())

        ImagePanel.addSubview(leftButton)
        ImagePanel.addSubview(rightButton)
        
        leftButton.anchorToEdge(Edge.Left, padding: 0, width: 58.LayoutVal(), height: ImagePanel.height)
        rightButton.anchorToEdge(Edge.Right, padding: 0, width: 58.LayoutVal(), height: ImagePanel.height)
        
        leftButton.addSubview(leftArr)
        rightButton.addSubview(rightArr)
        
        leftArr.anchorToEdge(Edge.Right, padding: 20.LayoutVal(), width: leftArr.width, height: leftArr.height)
        rightArr.anchorToEdge(Edge.Left, padding: 20.LayoutVal(), width: rightArr.width, height: rightArr.height)

        let imgArr = imgUrlList!.componentsSeparatedByString(",")

        let imgList = UIScrollView()
        ImagePanel.addSubview(imgList)
        imgList.align(Align.ToTheRightCentered, relativeTo: leftButton,
                      padding: 0, width: 634.LayoutVal(), height: 145.LayoutVal())
        
        var prevImg: YMTouchableImageView? = nil
        for imgUrl in imgArr {
            prevImg = ShowImage(imgList, imgUrl: imgUrl, prev: prevImg)
        }
        
        YMLayout.SetHScrollViewContentSize(imgList, lastSubView: prevImg)
    }

    private func DrawTimelineTypeIcon(type: String, prev: UIView?, idx: Int, lastIdx: Int) -> UIImageView {
        var realType = type
        if("notepad" == type) {
            if(idx == lastIdx) {
                realType = "lastNotepad"
            }
        }
        
        let icon = YMLayout.GetSuitableImageView(TimelineIconMap[realType]!)
        
        TimeLinePanel.addSubview(icon)

        if(nil == prev) {
            icon.anchorInCorner(Corner.TopLeft,
                                xPad: 204.LayoutVal(), yPad: 40.LayoutVal(),
                                width: icon.width, height: icon.height)
        } else {
            icon.align(Align.UnderCentered, relativeTo: prev!,
                       padding: 10.LayoutVal(), width: icon.width, height: icon.height)
        }
        
        return icon
    }
    
    private func DrawTimelineTimelabel(time: String, icon: UIImageView) {
        let timeArr = time.componentsSeparatedByString(" ")
        
        let day = timeArr[0]
        let time = timeArr[1]
        
        let dayLabel = UILabel()
        let timeLabel = UILabel()
        
        func SetTimelableStyle(text: String, label: UILabel) {
            label.text = text
            label.textColor = YMColors.PatientFontGreen
            label.font = YMFonts.YMDefaultFont(22.LayoutVal())
            label.sizeToFit()
        }
        
        TimeLinePanel.addSubview(dayLabel)
        TimeLinePanel.addSubview(timeLabel)
        
        SetTimelableStyle(day, label: dayLabel)
        SetTimelableStyle(time, label: timeLabel)
        
        dayLabel.align(Align.ToTheLeftCentered, relativeTo: icon,
                       padding: 28.LayoutVal(), width: dayLabel.width, height: dayLabel.height)
        timeLabel.align(Align.UnderMatchingLeft, relativeTo: dayLabel,
                        padding: 4.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
    }
    
    private func DrawTimelineInfoDetail(detail: [String: AnyObject], prev: UIView) -> UIView {
        let detailCell = UIView()
        TimeLinePanel.addSubview(detailCell)
        
        let cellFullWidth = 420.LayoutVal()
        detailCell.align(Align.UnderMatchingLeft,
                         relativeTo: prev, padding: 10.LayoutVal(),
                         width: cellFullWidth, height: 0)
        
        let title = UILabel()
        title.text = detail["name"] as? String
        title.textColor = YMColors.FontLightGray
        title.font = YMFonts.YMDefaultFont(24.LayoutVal())
        title.sizeToFit()
        
        detailCell.addSubview(title)
        title.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 10.LayoutVal(),
                             width: title.width, height: title.height)
        
        let contentWidth = cellFullWidth - title.width - 16.LayoutVal()
        let contentInnerWidth = contentWidth - 20.LayoutVal()
        
        let content = detail["content"] as? String
        if(nil != content) {
            let contentCell = UIView()
            let contentLabel = UILabel()
            
            detailCell.addSubview(contentCell)
            contentCell.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 0, width: contentWidth, height: 0)
            contentCell.backgroundColor = YMColors.DividerLineGray
            contentCell.addSubview(contentLabel)
            
            contentLabel.text = content!
            contentLabel.textColor = YMColors.PatientFontGreen
            contentLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
            contentLabel.numberOfLines = 0
            contentLabel.frame = CGRectMake(0, 0, contentInnerWidth, 0)
            contentLabel.sizeToFit()
            
            contentLabel.anchorInCorner(Corner.TopLeft, xPad: 10.LayoutVal(), yPad: 9.LayoutVal(),
                                        width: contentLabel.width, height: contentLabel.height)
            
            YMLayout.SetViewHeightByLastSubview(contentCell, lastSubView: contentLabel, bottomPadding: 10.LayoutVal())
            YMLayout.SetViewHeightByLastSubview(detailCell, lastSubView: contentCell)
        }
        
        return detailCell
    }

    private func DrawTimelineInfo(info: [String: AnyObject], icon: UIImageView) -> UIView {
        let title = info["text"] as! String
        let detailInfo = info["other"] as? [[String: AnyObject]]
        
        var prev: UIView
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        titleLabel.numberOfLines = 0
        titleLabel.frame = CGRectMake(0, 0, 420.LayoutVal(), 0)
        titleLabel.sizeToFit()
        
        TimeLinePanel.addSubview(titleLabel)
        titleLabel.align(Align.ToTheRightCentered, relativeTo: icon,
                         padding: 28.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        prev = titleLabel

        if(nil != detailInfo) {
            for v in detailInfo! {
                prev = DrawTimelineInfoDetail(v, prev: prev)
            }
        }
        
        return prev
    }
    
    private func DrawLine(detailCell: UIView, icon: UIImageView) -> UIView {
        let line = UIView()
        TimeLinePanel.addSubview(line)
        line.backgroundColor = YMColors.PatientFontGreen
        line.align(Align.UnderCentered, relativeTo: icon, padding: 10.LayoutVal(),
                   width: YMSizes.OnPx, height: detailCell.frame.origin.y - icon.frame.origin.y + 45.LayoutVal())
        return line
    }

    private func DrawTimeline(data: [[String: AnyObject]]) {
        BodyView.addSubview(TimeLinePanel)
        TimeLinePanel.align(Align.UnderMatchingLeft, relativeTo: ImagePanel,
                            padding: 0, width: YMSizes.PageWidth, height: 0)
        
        if(0 == data.count) {
            return
        }
        
        var prevLine: UIView? = nil
        var detailCell: UIView? = nil
        let lastIdx = data.count - 1
        for (k, v) in data.enumerate() {
            let time = v["time"] as? String
            let type = v["type"] as! String
            let info = v["info"] as! [String: AnyObject]

            let icon = DrawTimelineTypeIcon(type, prev: prevLine, idx: k, lastIdx: lastIdx)

            if(nil != time) {
                DrawTimelineTimelabel(time!, icon: icon)
            }
            
            detailCell = DrawTimelineInfo(info, icon: icon)
            
            if(k != lastIdx) {
                prevLine = DrawLine(detailCell!, icon: icon)
            }
        }
        
        YMLayout.SetViewHeightByLastSubview(TimeLinePanel, lastSubView: detailCell!, bottomPadding: 10.LayoutVal())
    }
    
    private func SetBreadcrumbsEnabel(label: UILabel) {
        label.backgroundColor = YMColors.PatientFontGreen
        label.textColor = YMColors.White
    }
    
    private func SetBreadcrumbsDisable(label: UILabel) {
        label.backgroundColor = YMColors.CommonBottomGray
        label.textColor = YMColors.FontGray
    }
    
    private func ResetBreadcrumbs() {
        let controllerMap = Breadcrumbs.UserObjectData as! [String: AnyObject]
        let start = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_START] as! UILabel
        let patientConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_PATIENT_CONFIRM] as! UILabel
        let docConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_DOC_CONFIRM] as! UILabel
        let end = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_END] as! UILabel
        
        let indc = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_INDC] as! UILabel
        
        SetBreadcrumbsDisable(start)
        SetBreadcrumbsDisable(patientConfirm)
        SetBreadcrumbsDisable(docConfirm)
        SetBreadcrumbsDisable(end)
        
        indc.text = ""
    }
    
    private func SetBreadcrumbs(data: [String: AnyObject]) {
        let milestone = data["milestone"] as? String
        let status = data["status"] as? String

        if(nil == milestone) {
            return
        }
        
        let controllerMap = Breadcrumbs.UserObjectData as! [String: AnyObject]
        let start = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_START] as! UILabel
        let patientConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_PATIENT_CONFIRM] as! UILabel
        let docConfirm = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_DOC_CONFIRM] as! UILabel
        let end = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_LABEL_END] as! UILabel
        
        let indc = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_INDC] as! UILabel

        let arr1 = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_ARR_1] as! UIImageView
        let arr2 = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_ARR_2] as! UIImageView
        let arr3 = controllerMap[YMAppointmentDetailStrings.BREADCRUMBS_ARR_3] as! UIImageView
        
        if("发起约诊" == milestone!) {
            SetBreadcrumbsEnabel(start)

            if(nil != status) {
                indc.text = status!
                indc.sizeToFit()
                indc.align(Align.UnderCentered, relativeTo: arr1, padding: 22.LayoutVal(),
                           width: indc.width, height: indc.height)
            }
        } else if("患者确认" == milestone || "确认预约" == milestone) {
            SetBreadcrumbsEnabel(start)
            SetBreadcrumbsEnabel(patientConfirm)
            
            if(nil != status) {
                indc.text = status!
                indc.sizeToFit()
                indc.align(Align.UnderCentered, relativeTo: arr2, padding: 22.LayoutVal(),
                           width: indc.width, height: indc.height)
            }
        } else if("医生确认" == milestone) {
            SetBreadcrumbsEnabel(start)
            SetBreadcrumbsEnabel(patientConfirm)
            SetBreadcrumbsEnabel(docConfirm)
            
            if(nil != status) {
                indc.text = status!
                indc.sizeToFit()
                indc.align(Align.UnderCentered, relativeTo: arr3, padding: 22.LayoutVal(),
                           width: indc.width, height: indc.height)
            }
        } else {
            SetBreadcrumbsEnabel(start)
            SetBreadcrumbsEnabel(patientConfirm)
            SetBreadcrumbsEnabel(docConfirm)
            SetBreadcrumbsEnabel(end)
        }
    }
    
    func DrawBottom() {
        let status = PageAppointmentDetailViewController.RecordInfo["status"] as! String
        
        let statusCode = YMVar.GetStringByKey(PageAppointmentDetailViewController.RecordInfo, key: "status_code")

        GoToPayBtn.setTitle("", forState: UIControlState.Normal)
        GoToPayBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        GoToPayBtn.backgroundColor = YMColors.PatientFontGreen
        GoToPayBtn.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        ConfirmBtn.setTitle("", forState: UIControlState.Normal)
        ConfirmBtn.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmBtn.backgroundColor = YMColors.PatientFontGreen
        ConfirmBtn.titleLabel?.font = YMFonts.YMDefaultFont(32.LayoutVal())
        
        if(status.containsString("保证金")) {
            ParentView!.addSubview(GoToPayBtn)
            GoToPayBtn.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
            GoToPayBtn.setTitle("缴纳保证金", forState: UIControlState.Normal)
            
            GoToPayBtn.addTarget(DetailActions, action: "GoToPayTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        } else if(status.containsString("诊费")) {
            ParentView!.addSubview(GoToPayBtn)
            GoToPayBtn.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
            GoToPayBtn.setTitle("缴纳诊费", forState: UIControlState.Normal)
            GoToPayBtn.addTarget(DetailActions, action: "GoToPayTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        } else if("wait-4" == statusCode) {
            ParentView?.addSubview(ConfirmBtn)
            ConfirmBtn.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: 98.LayoutVal())
            ConfirmBtn.setTitle("确认改期", forState: UIControlState.Normal)
            ConfirmBtn.addTarget(DetailActions, action: "ConfirmTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }

    public func LoadData(data: NSDictionary) {
        let otherInfo = data["other_info"] as! [String: AnyObject]
        let progress = otherInfo["progress"] as! [String: AnyObject]
        let timeLine = otherInfo["time_line"] as! [[String: AnyObject]]
        
        let doc = data["doctor_info"] as! [String: AnyObject]
        let patient = data["patient_info"] as! [String: AnyObject]
        let locumsDoctorInfo = data["locums_doctor_info"] as! [String: AnyObject]
        
        let locumsDoctorId = YMVar.GetStringByKey(locumsDoctorInfo, key: "id")
        let docId = YMVar.GetStringByKey(doc, key: "id")
        
        SetBreadcrumbs(progress)
        if("" == locumsDoctorId) {
            DrawDocOnlyPanel(doc)
            PlatformCell.hidden = true
            DocOnlyCell.hidden = false
        } else {
            if("1" == locumsDoctorId) {
                DrawPlatformPanel()
                PlatformCell.hidden = false
                DocOnlyCell.hidden = true
            } else if (locumsDoctorId != docId) {
                DrawProxyDorctor(locumsDoctorInfo)
                DrawDorctor(doc)
                PlatformCell.hidden = true
                DocOnlyCell.hidden = true
            } else {
                DrawDocOnlyPanel(doc)
                PlatformCell.hidden = true
                DocOnlyCell.hidden = false
            }
        }
        
//        DrawPatient(patient)
        AppointmentNum.text = PageAppointmentDetailViewController.AppointmentID
        DrawTextInfo(patient)
        DrawImageList(patient)
        DrawTimeline(timeLine)
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: TimeLinePanel, padding: 128.LayoutVal())
        FullPageLoading?.Hide()
        
        DrawBottom()

    }
    
    public func GetDetail() {
        DetailActions?.GetDetail()
    }
    
    public func Clear() {
        ResetBreadcrumbs()
        YMLayout.ClearView(view: DocCell)
        YMLayout.ClearView(view: ProxyDocCell)
        YMLayout.ClearView(view: PlatformCell)
        YMLayout.ClearView(view: DocOnlyCell)
        YMLayout.ClearView(view: PatientCell)
        YMLayout.ClearView(view: TextInfoPanel)
        YMLayout.ClearView(view: ImagePanel)
        YMLayout.ClearView(view: TimeLinePanel)
        
        GoToPayBtn.removeFromSuperview()
        GoToPayBtn.removeTarget(nil, action: "GoToPayTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        ConfirmBtn.removeFromSuperview()
        ConfirmBtn.removeTarget(nil, action: "ConfirmTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
    }
}




























