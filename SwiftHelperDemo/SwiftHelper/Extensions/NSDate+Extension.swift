//
//  NSDate.swift
//  YST
//
//  Created by LiuChang on 16/8/16.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension NSDate {
    
    var year: Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self).year
    }
    
    var month: Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: self).month
    }

    var day: Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: self).day
    }

    var hour: Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: self).hour
    }

    var minute: Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: self).minute
    }

    var second: Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: self).second
    }
    
    var nanosecond: Int {
        return NSCalendar.currentCalendar().components(.Nanosecond, fromDate: self).nanosecond
    }
    
    var weekday: Int {
        return NSCalendar.currentCalendar().components(.Weekday, fromDate: self).weekday
    }
    
    var weekdayOrdinal: Int {
        return NSCalendar.currentCalendar().components(.WeekdayOrdinal, fromDate: self).weekdayOrdinal
    }

    var weekOfMonth: Int {
        return NSCalendar.currentCalendar().components(.WeekOfMonth, fromDate: self).weekOfMonth
    }

    var weekOfYear: Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: self).weekOfYear
    }
    
    var yearForWeekOfYear: Int {
        return NSCalendar.currentCalendar().components(.YearForWeekOfYear, fromDate: self).yearForWeekOfYear
    }
    
    var quarter: Int {
        return NSCalendar.currentCalendar().components(.Quarter, fromDate: self).quarter
    }
    
    var isLeapMonth: Bool {
        return NSCalendar.currentCalendar().components(.Quarter, fromDate: self).leapMonth
    }
    
    var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    var isToday: Bool {
        if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) {
            return false
        }
        return NSDate().day == self.day
    }
    
    var isYesterday: Bool {
        let date = self.dateByAddingDays(1)
        return date.isToday
    }
    
    var string: String {
        return self.stringWithDateFormat("yyyyMMddHHmmss")
    }
    
    func stringWithDateFormat(string: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = string
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromDate(self)
    }

}

// add
extension NSDate {
    
    func dateByAddingYears(years: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = years
        return calender.dateByAddingComponents(components, toDate: self, options: .WrapComponents)!
    }
    
    func dateByAddingMonths(months: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = months
        return calender.dateByAddingComponents(components, toDate: self, options: .WrapComponents)!
    }
    
    func dateByAddingWeeks(weeks: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.weekOfYear = weeks
        return calender.dateByAddingComponents(components, toDate: self, options: .WrapComponents)!
    }
    
    func dateByAddingDays(days: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(86400 * days)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    func dateByAddingHours(hours: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(3600 * hours)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    func dateByAddingMinutes(minutes: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(60 * minutes)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    func dateByAddingSeconds(seconds: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(seconds)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }

}

