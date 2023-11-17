//
//  Date+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/8/16.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import Foundation

extension Date: SwiftHelperCompatibleValue {}
public extension SwiftHelperWrapper where Base == Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: base)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: base)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: base)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: base)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: base)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: base)
    }
    
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: base)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: base)
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: base)
    }
    
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: base)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: base)
    }
    
    var yearForWeekOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: base)
    }
    
    var quarter: Int {
        return Calendar.current.component(.quarter, from: base)
    }
    
    var isLeapMonth: Bool {
        return (Calendar.current as NSCalendar).components(.quarter, from: base).isLeapMonth!
    }
    
    var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    var isToday: Bool {
        if (fabs(base.timeIntervalSinceNow) >= 60 * 60 * 24) {
            return false
        }
        return Date().sh.day == self.day
    }
    
    var isYesterday: Bool {
        let date = self.addDays(1)
        return date.sh.isToday
    }
    
    var string: String {
        return string(dateFormat: "yyyyMMddHHmmss")
    }
    
    func string(dateFormat string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = string
        formatter.locale = Locale.current
        return formatter.string(from: base)
    }
    
}

// add
public extension SwiftHelperWrapper where Base == Date {

    func addYears(_ years: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.year = years
        return calender.date(byAdding: components, to: base)!
    }
    
    func addMonths(_ months: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.month = months
        return calender.date(byAdding: components, to: base)!
    }
    
    func addWeeks(_ weeks: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.weekOfYear = weeks
        return calender.date(byAdding: components, to: base)!
    }
    
    func addDays(_ days: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.day = days
        return calender.date(byAdding: components, to: base)!
    }
    
    func addHours(_ hours: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.hour = hours
        return calender.date(byAdding: components, to: base)!
    }
    
    func addMinutes(_ minutes: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.minute = minutes
        return calender.date(byAdding: components, to: base)!
    }
    
    func addSeconds(_ seconds: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.second = seconds
        return calender.date(byAdding: components, to: base)!
    }

}

