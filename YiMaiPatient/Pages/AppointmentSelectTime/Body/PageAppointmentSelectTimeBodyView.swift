//
//  PageAppointmentSelectTimeBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/6/2.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftDate
import ChameleonFramework

public class PageAppointmentSelectTimeBodyView: PageBodyView {
    
    private let DoctorHeadlinePanel = UIView()
    private let CalendarPanel = UIView()
    
    private let CellInnerWidth = 80.LayoutVal()
    private let CellInnerHeight = 56.LayoutVal()
    
    private var SelectedDays = [String: String]()
    private var SelectedFullDate = [String: String]()
    private var SelectedAMorPM = [String: String]()
    
    private var LastView: UIView? = nil
    
    override func ViewLayout() {
        super.ViewLayout()
        
        DrawDoctorCell()
        DrawCalendar()
        DrawButton()
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: LastView)
    }
    
    public func SetSelectedDays(cell: YMTouchableView) {
        var userData = cell.UserObjectData! as! [String:AnyObject]
        
        let untouchable = userData[YMAppointmentStrings.CS_CALENDAR_TOUCHABLE_CELL_KEY] as! Bool
        let touchedStatus = userData[YMAppointmentStrings.CS_CALENDAR_TOUCH_STATUS_KEY] as! Bool
        let innerCell = userData[YMAppointmentStrings.CS_CALENDAR_CELL_INNER_KEY] as! UIView
        let date = userData[YMAppointmentStrings.CS_CALENDAR_CELL_DATE_KEY] as! String
        let fullDate = userData[YMAppointmentStrings.CS_CALENDAR_CELL_FULL_DATE_KEY] as! String
        let amOrPM = userData[YMAppointmentStrings.CS_CALENDAR_CELL_AM_OR_PM_KEY] as! String
        
        if(untouchable) {
            return
        }
        
        if(touchedStatus) {
            SelectedDays.removeValueForKey(date)
            SelectedFullDate.removeValueForKey(fullDate)
            SelectedAMorPM.removeValueForKey(fullDate)
            innerCell.backgroundColor = YMColors.PanelBackgroundGray
            userData[YMAppointmentStrings.CS_CALENDAR_TOUCH_STATUS_KEY] = false
        } else {
            if(SelectedDays.count < 3){
                SelectedDays[date] = date
                SelectedFullDate[fullDate] = fullDate
                SelectedAMorPM[fullDate] = amOrPM
                userData[YMAppointmentStrings.CS_CALENDAR_TOUCH_STATUS_KEY] = true
                innerCell.backgroundColor = YMColors.PatientFontGreen
            }
        }
        
        cell.UserObjectData = userData
    }
    
    public func GetSelectedDays() -> String {
        var ret = ""
        for (_,v) in SelectedDays {
            ret += v + "  "
        }
        
        return ret
    }
    
    public func GetSelectedDaysForUpload() -> [String] {
        var ret = [String]()
        
        var date = [String]()
        var amOrPm = [String]()
        for (k,v) in SelectedFullDate {
            date.append(v)
            amOrPm.append(SelectedAMorPM[k]!)
        }
        
        ret.append(date.joinWithSeparator(","))
        ret.append(amOrPm.joinWithSeparator(","))
        return ret
    }
    
    private func DrawDoctorCell(data: [String: AnyObject]?, docPanel: UIView) {
        if(nil == data) {return}
        
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
        nameLabel.textColor = YMColors.PatientFontGreen
        nameLabel.font = YMFonts.YMDefaultFont(30.LayoutVal())
        nameLabel.sizeToFit()
        
        divider.backgroundColor = YMColors.PatientFontGreen
        
        jobTitleLabel.text = jobTitle
        jobTitleLabel.textColor = YMColors.FontGray
        jobTitleLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        jobTitleLabel.sizeToFit()
        
        deptLabel.text = department["name"] as? String
        deptLabel.textColor = YMColors.PatientFontGreen
        deptLabel.font = YMFonts.YMDefaultFont(22.LayoutVal())
        deptLabel.sizeToFit()
        
        hosLabel.text = hospital["name"] as? String
        hosLabel.textColor = YMColors.FontGray
        hosLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        hosLabel.sizeToFit()
        hosLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        let cell = UIView()
        
        cell.addSubview(userHeadBackground)
        cell.addSubview(nameLabel)
        cell.addSubview(divider)
        cell.addSubview(jobTitleLabel)
        cell.addSubview(deptLabel)
        cell.addSubview(hosLabel)
        
        docPanel.addSubview(cell)

        cell.fillSuperview()
        
        userHeadBackground.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHeadBackground.width, height: userHeadBackground.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 25.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divider.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 15.LayoutVal(), width: YMSizes.OnPx, height: divider.height)
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divider, padding: 15.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 6.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        hosLabel.align(Align.UnderMatchingLeft, relativeTo: deptLabel, padding: 6.LayoutVal(), width: 540.LayoutVal(), height: hosLabel.height)
    }
    
    private func DrawDoctorCell() {
        BodyView.addSubview(DoctorHeadlinePanel)
        DoctorHeadlinePanel.backgroundColor = YMColors.None
        DoctorHeadlinePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 190.LayoutVal())
        
        let innerPanel = UIView()
        DoctorHeadlinePanel.addSubview(innerPanel)
        innerPanel.anchorInCenter(width: YMSizes.PageWidth, height: 150.LayoutVal())
        
        let bottomLine = UIView()
        DoctorHeadlinePanel.addSubview(bottomLine)
        bottomLine.backgroundColor = YMColors.DividerLineGray
        bottomLine.anchorToEdge(Edge.Bottom, padding: 0, width: YMSizes.PageWidth, height: YMSizes.OnPx)
        
        DrawDoctorCell(PageAppointmentViewController.SelectedDoctor, docPanel: innerPanel)
        
    }
    
    private func GetCalendarLabelCell(label: String, width: CGFloat, height: CGFloat) -> UIView {
        let cell = UIView()
        let cellLabel = UILabel()
        
        cellLabel.text = label
        cellLabel.textColor = YMColors.PatientFontGreen
        cellLabel.textAlignment = NSTextAlignment.Center
        cellLabel.font = YMFonts.YMDefaultFont(24.LayoutVal())
        cellLabel.backgroundColor = YMColors.PanelBackgroundGray
        
        cell.addSubview(cellLabel)
        cellLabel.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 0, width: width, height: height)
        
        cell.backgroundColor = YMColors.DividerLineGray
        return cell
    }
    
    private func DrawCalendarOptCell(date:NSDate, AMorPM: String, AMorPMEng: String) -> UIView {
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "DateSelected:".Sel())
        let format = DateFormat.Custom("MM月dd日")
        let fullFormat = DateFormat.Custom("YYYY-MM-dd")
        
        cell.backgroundColor = YMColors.DividerLineGray
        var userData = [String: AnyObject]()
        
        let cellInner = UIView()
        cell.addSubview(cellInner)
        
        let untouchable = date.isInWeekend()!
        if(untouchable) {
            cellInner.backgroundColor = YMColors.UntouchableCellGray
        } else {
            cellInner.backgroundColor = YMColors.PanelBackgroundGray
        }
        cellInner.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 0, width: CellInnerWidth, height: CellInnerHeight)
        
        userData[YMAppointmentStrings.CS_CALENDAR_TOUCHABLE_CELL_KEY] = untouchable
        userData[YMAppointmentStrings.CS_CALENDAR_TOUCH_STATUS_KEY] = false
        userData[YMAppointmentStrings.CS_CALENDAR_CELL_INNER_KEY] = cellInner
        userData[YMAppointmentStrings.CS_CALENDAR_CELL_DATE_KEY] = date.toString(format)! + AMorPM
        userData[YMAppointmentStrings.CS_CALENDAR_CELL_FULL_DATE_KEY] = date.toString(fullFormat)!
        userData[YMAppointmentStrings.CS_CALENDAR_CELL_AM_OR_PM_KEY] = AMorPMEng
        
        cell.UserObjectData = userData
        
        return cell
    }
    
    private func DrawWeek(start: NSDate) -> UIView {
        let calendarView = UIView()
        calendarView.backgroundColor = YMColors.DividerLineGray
        let format = DateFormat.Custom("MM/dd")

        let cellWidth = CellInnerWidth + 1
        let cellHeight = CellInnerHeight + 1
        
        let calendarTitle = UIView()
        
        calendarTitle.backgroundColor = YMColors.DividerLineGray
        let calendarTitleInner = UIView()
        calendarTitle.addSubview(calendarTitleInner)
        calendarTitleInner.backgroundColor = YMColors.PanelBackgroundGray
        calendarTitleInner.anchorInCorner(Corner.TopLeft, xPad: 0, yPad: 0,
                                          width: 92.LayoutVal(), height: 72.LayoutVal())
        
        
        let calendarTitleImage = YMLayout.GetSuitableImageView("CommonCalendarTitle")
        calendarTitleInner.addSubview(calendarTitleImage)
        calendarTitleImage.fillSuperview()
        
        let calendarAM = GetCalendarLabelCell("上午", width: 92.LayoutVal(), height: 56.LayoutVal())
        let calendarPM = GetCalendarLabelCell("下午", width: 92.LayoutVal(), height: 56.LayoutVal())
        
        calendarView.addSubview(calendarTitle)
        calendarView.addSubview(calendarAM)
        calendarView.addSubview(calendarPM)
        
        calendarTitle.anchorInCorner(Corner.TopLeft, xPad: 1, yPad: 1, width: 92.LayoutVal() + 1, height: 72.LayoutVal() + 1)
        calendarAM.align(Align.UnderMatchingLeft,
                         relativeTo: calendarTitle,
                         padding: 0,
                         width: 92.LayoutVal() + 1, height: cellHeight)
        calendarPM.align(Align.UnderMatchingLeft,
                         relativeTo: calendarAM,
                         padding: 0,
                         width: 92.LayoutVal() + 1, height: cellHeight)
        
        var rowDatePrevView = calendarTitle
        var lastPMCell: UIView = UIView()

        for i in  0...6 {
            let thisDay = (start+i.days)
            let dateTitle = thisDay.toString(format)! as String
            
            let dateTitleCell = GetCalendarLabelCell(dateTitle, width: 80.LayoutVal(), height: 72.LayoutVal())
            let amCell = DrawCalendarOptCell(thisDay, AMorPM: "上午", AMorPMEng: "am")
            let pmCell = DrawCalendarOptCell(thisDay, AMorPM: "下午", AMorPMEng: "pm")
            
            calendarView.addSubview(dateTitleCell)
            calendarView.addSubview(amCell)
            calendarView.addSubview(pmCell)
            
            dateTitleCell.align(Align.ToTheRightMatchingTop,
                                relativeTo: rowDatePrevView,
                                padding: 0,
                                width: cellWidth, height: 72.LayoutVal() + 1)
            
            amCell.align(Align.UnderMatchingLeft,
                             relativeTo: dateTitleCell,
                             padding: 0,
                             width: cellWidth, height: cellHeight)
            pmCell.align(Align.UnderMatchingLeft,
                             relativeTo: amCell,
                             padding: 0,
                             width: cellWidth, height: cellHeight)
            
            rowDatePrevView = dateTitleCell
            lastPMCell = pmCell
            
        }
        
        calendarView.frame = CGRect(x: 0,y: 0,
                                    width: lastPMCell.frame.origin.x+lastPMCell.width,
                                    height: lastPMCell.frame.origin.y+lastPMCell.height)

        return calendarView
    }
    
    private func DrawCalendar() {
        let now = NSDate()
        BodyView.addSubview(CalendarPanel)
        CalendarPanel.align(Align.UnderMatchingLeft,
                            relativeTo: DoctorHeadlinePanel,
                            padding: 0,
                            width: YMSizes.PageWidth, height: 556.LayoutVal())
        
        let headLine = UILabel()
        let priceLine = UILabel()
        let bottomLine = UILabel()
        
        headLine.text = "以下空白区域为医生近期可选时间"
        headLine.textColor = YMColors.FontGray
        headLine.font = YMFonts.YMDefaultFont(24.LayoutVal())
        headLine.sizeToFit()
        
        priceLine.text = "约诊费200/次"
        priceLine.textColor = YMColors.PatientFontGreen
        priceLine.font = YMFonts.YMDefaultFont(30.LayoutVal())
        priceLine.sizeToFit()
        
        bottomLine.text = "最多可选三个时段（灰色不可选）"
        bottomLine.textColor = YMColors.FontGray
        bottomLine.font = YMFonts.YMDefaultFont(24.LayoutVal())
        bottomLine.sizeToFit()
        
        CalendarPanel.addSubview(headLine)
        CalendarPanel.addSubview(priceLine)
        CalendarPanel.addSubview(bottomLine)
        
        headLine.anchorInCorner(Corner.TopLeft,
                                xPad: 40.LayoutVal(),
                                yPad: 45.LayoutVal(),
                                width: headLine.width, height: headLine.height)
        
        priceLine.anchorInCorner(Corner.TopRight,
                                xPad: 40.LayoutVal(),
                                yPad: 40.LayoutVal(),
                                width: priceLine.width, height: priceLine.height)
        
        bottomLine.anchorInCorner(Corner.BottomLeft,
                                  xPad: 40.LayoutVal(),
                                  yPad: 0,
                                  width: bottomLine.width, height: bottomLine.height)
        
        let calendarFirstWeek = DrawWeek(now)
        
        CalendarPanel.addSubview(calendarFirstWeek)
        calendarFirstWeek.align(Align.UnderMatchingLeft,
                                relativeTo: headLine,
                                padding: 20.LayoutVal(),
                                width: calendarFirstWeek.width, height: calendarFirstWeek.height)
        
        let calendarSencondWeek = DrawWeek(now+1.weeks)
        
        CalendarPanel.addSubview(calendarSencondWeek)
        calendarSencondWeek.align(Align.UnderMatchingLeft,
                                relativeTo: calendarFirstWeek,
                                padding: 30.LayoutVal(),
                                width: calendarFirstWeek.width, height: calendarFirstWeek.height)
    }
    
    private func DrawButton() {
        let okButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "OKButtonTouched:".Sel())
        let autoButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "AutoButtonTouched:".Sel())
        
        okButton.backgroundColor = YMColors.None
        autoButton.backgroundColor = YMColors.None
        
        BodyView.addSubview(okButton)
        BodyView.addSubview(autoButton)
        
        okButton.align(Align.UnderMatchingLeft, relativeTo: CalendarPanel, padding: 156.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        autoButton.align(Align.UnderMatchingLeft, relativeTo: okButton, padding: 20.LayoutVal(), width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        let okBkg = YMLayout.GetSuitableImageView("AppointmentSelectTimeOKButton")
        let autoBkg = YMLayout.GetSuitableImageView("AppointmentSelectTimeAutoButton")
        
        okButton.addSubview(okBkg)
        autoButton.addSubview(autoBkg)
        
        okBkg.anchorInCenter(width: okBkg.width, height: okBkg.height)
        autoBkg.anchorInCenter(width: autoBkg.width, height: autoBkg.height)
        
        let okLabel = UILabel()
        let autoLabel = UILabel()
        
        okLabel.text = "选好了"
        okLabel.textColor = YMColors.White
        okLabel.font = YMFonts.YMDefaultFont(34.LayoutVal())
        okLabel.sizeToFit()
        
        autoLabel.text = "由专家决定（推荐）"
        autoLabel.textColor = YMColors.White
        autoLabel.font = YMFonts.YMDefaultFont(34.LayoutVal())
        autoLabel.sizeToFit()
        
        okButton.addSubview(okLabel)
        autoButton.addSubview(autoLabel)
        
        okLabel.anchorInCenter(width: okLabel.width, height: okLabel.height)
        autoLabel.anchorInCenter(width: autoLabel.width, height: autoLabel.height)
        
        LastView = autoLabel
    }
}




















