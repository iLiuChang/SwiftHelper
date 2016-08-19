//
//  NSDate.swift
//  YST
//
//  Created by LiuChang on 16/8/16.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import UIKit

extension NSDate {
    
    public var year: Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self).year
    }
    
    public var month: Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: self).month
    }
    
    public var day: Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: self).day
    }
    
    public var hour: Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: self).hour
    }
    
    public var minute: Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: self).minute
    }
    
    public var second: Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: self).second
    }
    
    public var nanosecond: Int {
        return NSCalendar.currentCalendar().components(.Nanosecond, fromDate: self).nanosecond
    }
    
    public var weekday: Int {
        return NSCalendar.currentCalendar().components(.Weekday, fromDate: self).weekday
    }
    
    public var weekdayOrdinal: Int {
        return NSCalendar.currentCalendar().components(.WeekdayOrdinal, fromDate: self).weekdayOrdinal
    }
    
    public var weekOfMonth: Int {
        return NSCalendar.currentCalendar().components(.WeekOfMonth, fromDate: self).weekOfMonth
    }
    
    public var weekOfYear: Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: self).weekOfYear
    }
    
    public var yearForWeekOfYear: Int {
        return NSCalendar.currentCalendar().components(.YearForWeekOfYear, fromDate: self).yearForWeekOfYear
    }
    
    public var quarter: Int {
        return NSCalendar.currentCalendar().components(.Quarter, fromDate: self).quarter
    }
    
    public var isLeapMonth: Bool {
        return NSCalendar.currentCalendar().components(.Quarter, fromDate: self).leapMonth
    }
    
    public var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    public var isToday: Bool {
        if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) {
            return false
        }
        return NSDate().day == self.day
    }
    
    public var isYesterday: Bool {
        let date = self.dateByAddingDays(1)
        return date.isToday
    }
    
    public var string: String {
        return self.stringWithDateFormat("yyyyMMddHHmmss")
    }
    
    public func stringWithDateFormat(string: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = string
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromDate(self)
    }
    
}

// add
extension NSDate {
    
    public func dateByAddingYears(years: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = years
        return calender.dateByAddingComponents(components, toDate: self, options: .WrapComponents)!
    }
    
    public func dateByAddingMonths(months: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.month = months
        return calender.dateByAddingComponents(components, toDate: self, options: .WrapComponents)!
    }
    
    public func dateByAddingWeeks(weeks: Int) -> NSDate {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.weekOfYear = weeks
        return calender.dateByAddingComponents(components, toDate: self, options: .WrapComponents)!
    }
    
    public func dateByAddingDays(days: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(86400 * days)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    public func dateByAddingHours(hours: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(3600 * hours)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    public func dateByAddingMinutes(minutes: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(60 * minutes)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    public func dateByAddingSeconds(seconds: Int) -> NSDate {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(seconds)
        return NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }

}

