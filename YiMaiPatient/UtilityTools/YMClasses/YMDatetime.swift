//
//  YMDatetime.swift
//  YiMai
//
//  Created by why on 16/4/29.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftDate

public class YMDatetimeString {
    public static func Today() -> String {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        return timeFormatter.stringFromDate(NSDate()) as String
    }
    
    public static func Yesterday() -> String {
        let dayBeforeNow: NSDate = NSDate().dateByAddingTimeInterval(-24*60*60)
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        return timeFormatter.stringFromDate(dayBeforeNow) as String
    }
    
    public static func YYYYMMinChinese(date: NSDate) -> String {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy年MM月"
        return timeFormatter.stringFromDate(date) as String
    }
}

public class YMDateTools {
    public static func GetMonthDaysArrayInWeek(date: NSDate) -> [[Int]] {
        var dayCountInMonth =
            //12, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 01]
            [ 31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 31]
        
        let year = date.year
        let month = date.month
        let isLeapYear = date.isInLeapYear()!
        
        let prevMonth = month - 1
        
        if(isLeapYear) {
            dayCountInMonth[2] = 29
        }
        
        let initMonth = NSDate(year: year, month: month, day: 1)
        let firstWeekdayInMonth = initMonth.weekday
        
        let dayCountInThisMonth = dayCountInMonth[month]
        let prevMonthNeedFilling = firstWeekdayInMonth - 1
        var dayCountInFirstWeek = 7 - prevMonthNeedFilling
        let remainingCountInOtherWeek = dayCountInThisMonth - dayCountInFirstWeek
        let lastWeekdayCountInMonth = remainingCountInOtherWeek % 7
        var fullWeekCount = remainingCountInOtherWeek / 7
        let nextMonthNeedFilling = 7 - lastWeekdayCountInMonth
        
        var weekArray = [[Int]]()
        if(0 != prevMonthNeedFilling) {
            var firstWeek = [Int]()
            let prevMonthDayCount = dayCountInMonth[prevMonth]
            let firstFillingDay = prevMonthDayCount - prevMonthNeedFilling + 1
            for i in firstFillingDay...prevMonthDayCount {
                firstWeek.append(-i)
            }
            
            for i in 1...dayCountInFirstWeek {
                firstWeek.append(i)
            }
            
            weekArray.append(firstWeek)
        } else {
            dayCountInFirstWeek = 0
            fullWeekCount = fullWeekCount + 1
        }
        
        var dayIdx = dayCountInFirstWeek
        for _ in 1...fullWeekCount {
            var week = [Int]()
            
            week.append(dayIdx + 1)
            week.append(dayIdx + 2)
            week.append(dayIdx + 3)
            week.append(dayIdx + 4)
            week.append(dayIdx + 5)
            week.append(dayIdx + 6)
            week.append(dayIdx + 7)
            
            dayIdx += 7
            
            weekArray.append(week)
        }
        
        if(0 != nextMonthNeedFilling) {
            var lastWeek = [Int]()
            if(0 != lastWeekdayCountInMonth) {
                dayIdx += 1
                for i in dayIdx...dayCountInThisMonth {
                    lastWeek.append(i)
                }
            }
            
            for i in 1...nextMonthNeedFilling {
                lastWeek.append(i * 100)
            }
            
            weekArray.append(lastWeek)
        }
        
        return weekArray
    }
}