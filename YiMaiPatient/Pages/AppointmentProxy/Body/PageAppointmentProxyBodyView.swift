//
//  PageAppointmentBodyView.swift
//  YiMai
//
//  Created by why on 16/5/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import ChameleonFramework
import Photos

public class PageAppointmentProxyBodyView: PageBodyView {
    private var PatientBasicInfoPanel: YMTouchableView? = nil
    private var PatientConditionPanel: YMTouchableView? = nil
    private var PhotoIcon = YMLayout.GetSuitableImageView("PageAppointmentPhotoIcon")
    
    private var PhotoPanel: UIView? = nil
    private var PhotoInnerPanel: UIScrollView? = nil
    
    private var PhotoScrollLeftButton: YMTouchableView? = nil
    private var PhotoScrollRightButton: YMTouchableView? = nil
    
    private var ProxyInfoPanel = UIView()
    let ProxyInfoInput = YMTextArea(aDelegate: nil)
    
    private var SelectDoctorPanel: UIView? = nil
    private var SelectDoctorButton: YMTouchableView? = nil
    private let SelectDoctorButtonIcon = YMLayout.GetSuitableImageView("PageAppointmentAddDoctorIcon")
    private let SelectDoctorButtonLabel = UILabel()
    private var SelectedDoctorCell: UIView? = nil
    
    private var ConfirmButton: YMButton? = nil
    
    private var LastImage: UIView? = nil
    private var ImageCount: Int = 0
    
    public static var PatientBasicInfoString: String = ""
    public static var PatientConditionString: String = ""
    public static var AppointmentTimeString: String = "点击选择时间"
    private var AllowedSelection: UInt = 10
    public var PhotoPikcer: YMPhotoSelector? = nil
    public var PhotoArray = [UIImage]()

    public func DeleteImage() {
        AllowedSelection += 1
    }

    public func ImagesSelected(selectedPhotos: [PHAsset]) {
        for asset in selectedPhotos {
            let img = YMLayout.TransPHAssetToUIImage(asset)
            let imgView = UIImageView(image: img)

            self.PhotoArray.append(img)
            AddImage(imgView)
            
        }
        
        if(UInt(selectedPhotos.count) > AllowedSelection) {
            AllowedSelection = 0
        } else {
            AllowedSelection = AllowedSelection - UInt(selectedPhotos.count)
        }
        
        if(AllowedSelection > 10) {
            AllowedSelection = 0
        }
    }
    
    public func ShowPhotoPicker() {
        if(0 == AllowedSelection) {
            YMPageModalMessage.ShowNormalInfo("最多只能添加10张图片", nav: self.NavController!)
            return
        }
        PhotoPikcer?.SetMaxSelection(AllowedSelection)
        PhotoPikcer?.Show()
    }
    
    public func Reload() {
        self.DrawDocCell(PageAppointmentProxyViewController.SelectedDoctor)
        self.UpdateBasicInfo()
        self.UpdateCondition()
    }

    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = HexColor("#f0f0f0")
        
        PhotoPikcer = YMPhotoSelector(nav: self.NavController!, maxSelection: AllowedSelection)
        PhotoPikcer?.SelectedCallback = ImagesSelected

        DrawProxyInfo()
        DrawSelectDoctorPanel()
        DrawPatientBasicInfoPanel()
        DrawPatientConditionPanel()
        DrawPhotoPanel()
        DrawPhotoButton()
        DrawConfirmButton()
    }
    
    private func DrawProxyInfo() {
        BodyView.addSubview(ProxyInfoPanel)
        ProxyInfoPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 0)
        let title = YMLayout.GetNomalLabel("代约需求", textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        let titleView = UIView()
        
        ProxyInfoPanel.addSubview(titleView)
        titleView.addSubview(title)
        ProxyInfoPanel.addSubview(ProxyInfoInput)
        
        titleView.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 60.LayoutVal())
        title.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: title.width, height: title.height)
        ProxyInfoInput.align(Align.UnderMatchingLeft, relativeTo: titleView, padding: 0, width: YMSizes.PageWidth, height: 160.LayoutVal())
        ProxyInfoInput.placeholder = "填写代约需求（例如：医生姓名、医院、科室、职称、特长等）"
        ProxyInfoInput.MaxCharCount = 140
        ProxyInfoInput.font = YMFonts.YMDefaultFont(24.LayoutVal())
        ProxyInfoInput.backgroundColor = YMColors.White
        
        YMLayout.SetViewHeightByLastSubview(ProxyInfoPanel, lastSubView: ProxyInfoInput)
    }
    
    private func DrawPatientTextLabel(text: String, panel: UIView, textColor: UIColor) {
        let textLabel = UILabel()
        textLabel.text = text;
        textLabel.font = YMFonts.YMDefaultFont(28.LayoutVal())
        textLabel.textColor = textColor
        textLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        panel.addSubview(textLabel)
        textLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 630.LayoutVal(), height: 80.LayoutVal())
    }
    
    private func UpdateBasicInfo(){
        if(nil == PageAppointmentProxyViewController.PatientBasicInfo){
            DrawPatientBasicInfoPanel()
        } else {
            let info = PageAppointmentProxyViewController.PatientBasicInfo!
            let name = info["name"]!
            
            for view in PatientBasicInfoPanel!.subviews{
                view.removeFromSuperview()
            }
            
            DrawPatientTextLabel(name, panel: PatientBasicInfoPanel!, textColor: YMColors.FontGray)

        }
    }
    
    private func DrawPatientBasicInfoPanel() {
        PatientBasicInfoPanel = YMLayout.GetTouchableView(useObject: Actions!,
                                                          useMethod: PageJumpActions.PageJumpToByViewSenderSel,
                                                          userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_PROXY_PATIENT_BASIC_INFO_NAME)
        BodyView.addSubview(PatientBasicInfoPanel!)
//        PatientBasicInfoPanel?.anchorToEdge(Edge.Top, padding: 30.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        PatientBasicInfoPanel?.align(Align.UnderMatchingLeft, relativeTo: SelectDoctorPanel!,
            padding: 10.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())

        PatientBasicInfoPanel?.backgroundColor = HexColor("#f9f9f9")

        DrawPatientTextLabel("患者基本信息（必填）", panel: PatientBasicInfoPanel!, textColor: YMColors.FontGray)
    }
    
    private func UpdateCondition() {
        for view in PatientConditionPanel!.subviews{
            view.removeFromSuperview()
        }
        
        PatientConditionPanel?.backgroundColor = HexColor("#f9f9f9")

        if("" == PageAppointmentProxyViewController.PatientCondition){
            DrawPatientTextLabel("现病史", panel: PatientConditionPanel!, textColor: YMColors.FontGray)
        } else {
            DrawPatientTextLabel(PageAppointmentProxyViewController.PatientCondition, panel: PatientConditionPanel!, textColor: YMColors.FontGray)
        }
    }
    
    private func DrawPatientConditionPanel() {
        PatientConditionPanel = YMLayout.GetTouchableView(useObject: Actions!,
                                                          useMethod: PageJumpActions.PageJumpToByViewSenderSel,
                                                          userStringData: YMCommonStrings.CS_PAGE_APPOINTMENT_PROXY_PATIENT_CONDITION_NAME)
        BodyView.addSubview(PatientConditionPanel!)
        PatientConditionPanel?.backgroundColor = HexColor("#f9f9f9")
        PatientConditionPanel?.align(Align.UnderMatchingLeft, relativeTo: PatientBasicInfoPanel!,
                                     padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        DrawPatientTextLabel("现病史", panel: PatientConditionPanel!, textColor: YMColors.FontGray)
    }
    
    private func GetTooltipCell(info: String = "", prevCell: UIView? = nil, background: UIImageView? = nil) -> UIView {
        let cell = UIView()
        PhotoInnerPanel?.addSubview(cell)
        
        let titleLabel = UILabel()
        
        titleLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        titleLabel.numberOfLines = 2
        titleLabel.frame = CGRect(x: 0,y: 0,width: 66.LayoutVal(),height: 66.LayoutVal())
        titleLabel.text = info
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        
        titleLabel.sizeToFit()
        
        cell.addSubview(titleLabel)
        cell.backgroundColor = YMColors.BackgroundGray
        
        if(nil != prevCell) {
            cell.align(Align.ToTheRightMatchingTop, relativeTo: prevCell!, padding: 19.LayoutVal(), width: 144.LayoutVal(), height: 144.LayoutVal())
        } else {
            cell.anchorToEdge(Edge.Left, padding: 0, width: 144.LayoutVal(), height: 144.LayoutVal())
        }
        
        titleLabel.anchorInCenter(width: titleLabel.width, height: titleLabel.height)
        cell.layer.masksToBounds = true
        
        if(nil != background) {
            cell.addSubview(background!)
            background!.anchorInCenter(width: cell.width, height: cell.height)
        }
        
        return cell
    }
    
    private func DrawPhotoPanel() {
        PhotoPanel = UIView()
        BodyView.addSubview(PhotoPanel!)
        PhotoPanel?.align(Align.UnderMatchingLeft, relativeTo: PatientConditionPanel!, padding: 92.LayoutVal(), width: YMSizes.PageWidth, height: 254.LayoutVal())
        PhotoPanel?.backgroundColor = YMColors.White
        
        PhotoInnerPanel = UIScrollView()
        PhotoPanel?.addSubview(PhotoInnerPanel!)
        PhotoPanel?.backgroundColor = HexColor("#f9f9f9")
        
        PhotoInnerPanel?.anchorInCorner(Corner.TopLeft, xPad: 58.LayoutVal(), yPad: 80.LayoutVal(), width: 735.LayoutVal(), height: 144.LayoutVal())
        
        PhotoScrollLeftButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PhotoScrollLeft:".Sel())
        PhotoScrollRightButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "PhotoScrollRight:".Sel())
        PhotoScrollLeftButton?.backgroundColor = YMColors.None
        PhotoScrollRightButton?.backgroundColor = YMColors.None
        
        PhotoPanel?.addSubview(PhotoScrollLeftButton!)
        PhotoPanel?.addSubview(PhotoScrollRightButton!)
        
        let scrollLeftIcon = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollLeft")
        let scrollRightIcon = YMLayout.GetSuitableImageView("PageAppointmentPhotoScrollRight")
        
        PhotoScrollLeftButton?.addSubview(scrollLeftIcon)
        PhotoScrollRightButton?.addSubview(scrollRightIcon)

        PhotoScrollLeftButton?.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 80.LayoutVal(), width: 40.LayoutVal(), height: 144.LayoutVal())
        PhotoScrollRightButton?.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 80.LayoutVal(), width: 40.LayoutVal(), height: 144.LayoutVal())
        
        scrollLeftIcon.anchorToEdge(Edge.Right, padding: 0, width: scrollLeftIcon.width, height: scrollLeftIcon.height)
        scrollRightIcon.anchorToEdge(Edge.Left, padding: 0, width: scrollRightIcon.width, height: scrollRightIcon.height)
        
        var cell = GetTooltipCell("病例资料", prevCell: nil)
        cell = GetTooltipCell("病例资料", prevCell: cell)
        cell = GetTooltipCell("病例资料", prevCell: cell)
        cell = GetTooltipCell("其他", prevCell: cell)
    }
    
    private func DrawDocCell(data: [String: AnyObject]?) {
        if(nil == data) {return}
        
        SelectedDoctorCell = UIView()
        let dataObj = data!
        let head = dataObj[YMYiMaiStrings.CS_DATA_KEY_USERHEAD] as! String
        let name = dataObj[YMYiMaiStrings.CS_DATA_KEY_NAME] as! String
        let hospital = dataObj[YMYiMaiStrings.CS_DATA_KEY_HOSPATIL] as! [String: AnyObject]
        let department = dataObj[YMYiMaiStrings.CS_DATA_KEY_DEPARTMENT] as! [String: AnyObject]
        let jobTitle = dataObj[YMYiMaiStrings.CS_DATA_KEY_JOB_TITLE] as? String
        
        let nameLabel = UILabel()
        let divider = UIView(frame: CGRect(x: 0,y: 0,width: YMSizes.OnPx,height: 20.LayoutVal()))
        let jobTitleLabel = UILabel()
        let deptLabel = UILabel()
        let hosLabel = UILabel()
        let userHeadBackground = YMLayout.GetSuitableImageView("HeadImageBorder")
        
        YMLayout.LoadImageFromServer(userHeadBackground, url: head)
        nameLabel.text = name
        nameLabel.textColor = YMColors.FontBlue
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.FontBlue
        
        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.FontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = department["name"] as? String
        deptLabel.textColor = YMColors.FontBlue
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = hospital["name"] as? String
        hosLabel.textColor = YMColors.FontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail

        
        SelectedDoctorCell!.addSubview(userHeadBackground)
        SelectedDoctorCell!.addSubview(nameLabel)
        SelectedDoctorCell!.addSubview(divider)
        SelectedDoctorCell!.addSubview(jobTitleLabel)
        SelectedDoctorCell!.addSubview(deptLabel)
        SelectedDoctorCell!.addSubview(hosLabel)
        
        SelectDoctorButton!.addSubview(SelectedDoctorCell!)

        SelectedDoctorCell!.fillSuperview()
        SelectedDoctorCell?.backgroundColor = HexColor("#f9f9f9")

        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
    }
    
    private func DrawSelectDoctorPanel() {
        let titleLabel = UILabel()
        
        titleLabel.text = "代约医生"
        titleLabel.textColor = YMColors.FontGray
        titleLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        titleLabel.sizeToFit()
        
        SelectDoctorPanel = UIView()
        BodyView.addSubview(SelectDoctorPanel!)
        SelectDoctorPanel?.align(Align.UnderMatchingLeft, relativeTo: ProxyInfoPanel, padding: 0, width: YMSizes.PageWidth, height: 210.LayoutVal())
//        SelectDoctorPanel?.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 210.LayoutVal())
        
        SelectDoctorPanel?.addSubview(titleLabel)
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 0, width: titleLabel.width, height: 60.LayoutVal())
        
        SelectDoctorButton = YMTouchableView()
        
        SelectDoctorPanel?.addSubview(SelectDoctorButton!)
        SelectDoctorButton?.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 150.LayoutVal())
        
        SelectDoctorButton?.addSubview(SelectDoctorButtonIcon)
        SelectDoctorButtonIcon.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: SelectDoctorButtonIcon.width, height: SelectDoctorButtonIcon.height)
        
        
        SelectDoctorButtonLabel.textColor = YMColors.FontGray
        SelectDoctorButtonLabel.text = "点击选择医生"
        SelectDoctorButtonLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        SelectDoctorButtonLabel.sizeToFit()
        
        SelectDoctorButton?.addSubview(SelectDoctorButtonLabel)
        SelectDoctorButtonLabel.align(Align.ToTheRightCentered,
            relativeTo: SelectDoctorButtonIcon,
            padding: 24.LayoutVal(),
            width: SelectDoctorButtonLabel.width, height: SelectDoctorButtonLabel.height)
    }
    
    private func DrawPhotoButton() {
        let photoButton = YMLayout.GetTouchableImageView(useObject: Actions!, useMethod: "PhotoSelect:".Sel(), imageName: "PageAppointmentPhotoIcon")
        
        BodyView.addSubview(photoButton)
        photoButton.anchorToEdge(Edge.Top, padding: 575.LayoutVal(), width: photoButton.width, height: photoButton.height)
    }
    
    private func DrawConfirmButton() {
        ConfirmButton = YMButton()
        ParentView!.addSubview(ConfirmButton!)
        ConfirmButton?.anchorToEdge(Edge.Bottom, padding: 0.LayoutVal(), width: YMSizes.PageWidth, height: 98.LayoutVal())
        
        ConfirmButton?.addTarget(Actions!, action: "DoAppointment:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)

        ConfirmButton?.backgroundColor = YMColors.CommonBottomGray
        ConfirmButton?.setTitle("发送预约请求", forState: UIControlState.Normal)
        ConfirmButton?.setTitleColor(YMColors.FontGray, forState: UIControlState.Disabled)
        ConfirmButton?.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        ConfirmButton?.titleLabel?.font = YMFonts.YMDefaultFont(34.LayoutVal())
        ConfirmButton?.enabled = false

    }
    
    public func SetConfirmEnable() {
        ConfirmButton?.enabled = true
        ConfirmButton?.backgroundColor = YMColors.CommonBottomBlue
    }
    
    public func SetConfirmDisable() {
        ConfirmButton?.enabled = false
        ConfirmButton?.backgroundColor = YMColors.CommonBottomGray
    }
    
    public func AddImage(image: UIImageView) {
        self.LastImage = GetTooltipCell("病例资料", prevCell: LastImage, background: image)
        
        PhotoInnerPanel?.contentSize = CGSizeMake(
            self.LastImage!.frame.origin.x + self.LastImage!.width,
            PhotoInnerPanel!.height
        )
        
        ImageCount = ImageCount + 1
        
        if(ImageCount > 4){
            let x = CGFloat(ImageCount - 4) * (self.LastImage!.width + 19.LayoutVal())
            let pos = CGPointMake(x, self.LastImage!.frame.origin.y)
            PhotoInnerPanel?.setContentOffset(pos, animated: true)
        }
    }
}

































