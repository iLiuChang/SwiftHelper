//
//  Date+SH.swift
//  SwiftHelper (https://github.com/iLiuChang/SwiftHelper)
//
//  Created by LiuChang on 16/8/16.
//  Copyright © 2016年 LiuChang. All rights reserved.
//

import Foundation

public extension Date {
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: self)
    }
    
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var yearForWeekOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: self)
    }
    
    var quarter: Int {
        return Calendar.current.component(.quarter, from: self)
    }
    
    var isLeapMonth: Bool {
        return (Calendar.current as NSCalendar).components(.quarter, from: self).isLeapMonth!
    }
    
    var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)))
    }
    
    var isToday: Bool {
        if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) {
            return false
        }
        return Date().day == self.day
    }
    
    var isYesterday: Bool {
        let date = self.addDays(1)
        return date.isToday
    }
    
    var string: String {
        return string(dateFormat: "yyyyMMddHHmmss")
    }
    
    func string(dateFormat string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = string
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
}

// add
public extension Date {

    func addYears(_ years: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.year = years
        return calender.date(byAdding: components, to: self)!
    }
    
    func addMonths(_ months: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.month = months
        return calender.date(byAdding: components, to: self)!
    }
    
    func addWeeks(_ weeks: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.weekOfYear = weeks
        return calender.date(byAdding: components, to: self)!
    }
    
    func addDays(_ days: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.day = days
        return calender.date(byAdding: components, to: self)!
    }
    
    func addHours(_ hours: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.hour = hours
        return calender.date(byAdding: components, to: self)!
    }
    
    func addMinutes(_ minutes: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.minute = minutes
        return calender.date(byAdding: components, to: self)!
    }
    
    func addSeconds(_ seconds: Int) -> Date {
        let calender = Calendar.current
        var components = DateComponents()
        components.second = seconds
        return calender.date(byAdding: components, to: self)!
    }

}

