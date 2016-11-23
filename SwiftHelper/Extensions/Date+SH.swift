//
//  NSDate.swift
//  YST
//
//  Created by LiuChang on 16/8/16.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import Foundation

extension Date {
    
    public var year: Int {
        return (Calendar.current as NSCalendar).components(.year, from: self).year!
    }
    
    public var month: Int {
        return (Calendar.current as NSCalendar).components(.month, from: self).month!
    }
    
    public var day: Int {
        return (Calendar.current as NSCalendar).components(.day, from: self).day!
    }
    
    public var hour: Int {
        return (Calendar.current as NSCalendar).components(.hour, from: self).hour!
    }
    
    public var minute: Int {
        return (Calendar.current as NSCalendar).components(.minute, from: self).minute!
    }
    
    public var second: Int {
        return (Calendar.current as NSCalendar).components(.second, from: self).second!
    }
    
    public var nanosecond: Int {
        return (Calendar.current as NSCalendar).components(.nanosecond, from: self).nanosecond!
    }
    
    public var weekday: Int {
        return (Calendar.current as NSCalendar).components(.weekday, from: self).weekday!
    }
    
    public var weekdayOrdinal: Int {
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: self).weekdayOrdinal!
    }
    
    public var weekOfMonth: Int {
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: self).weekOfMonth!
    }
    
    public var weekOfYear: Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: self).weekOfYear!
    }
    
    public var yearForWeekOfYear: Int {
        return (Calendar.current as NSCalendar).components(.yearForWeekOfYear, from: self).yearForWeekOfYear!
    }
    
    public var quarter: Int {
        return (Calendar.current as NSCalendar).components(.quarter, from: self).quarter!
    }
    
    public var isLeapMonth: Bool {
        return (Calendar.current as NSCalendar).components(.quarter, from: self).isLeapMonth!
    }
    
    public var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    public var isToday: Bool {
        if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) {
            return false
        }
        return Date().day == self.day
    }
    
    public var isYesterday: Bool {
        let date = self.addDays(1)
        return date.isToday
    }
    
    public var string: String {
        return string(dateFormat: "yyyyMMddHHmmss")
    }
    
    public func string(dateFormat string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = string
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    
}

// add
extension Date {

    public func addYears(_ years: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.year = years
        return (calender as NSCalendar).date(byAdding: components, to: self, options: .wrapComponents)!
    }
    
    public func addMonths(_ months: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.month = months
        return (calender as NSCalendar).date(byAdding: components, to: self, options: .wrapComponents)!
    }
    
    public func addWeeks(_ weeks: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.weekOfYear = weeks
        return (calender as NSCalendar).date(byAdding: components, to: self, options: .wrapComponents)!
    }
    
    public func addDays(_ days: Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(86400 * days)
        return Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    public func addHours(_ hours: Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(3600 * hours)
        return Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    public func addMinutes(_ minutes: Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(60 * minutes)
        return Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }
    
    public func addSeconds(_ seconds: Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + Double(seconds)
        return Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
    }

}

