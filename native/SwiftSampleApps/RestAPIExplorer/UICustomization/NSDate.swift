//
//  Date.swift
//  CSMobileBase
//
//  Created by Jason Wells on 7/11/16.
//  Copyright © 2016 Jason Wells. All rights reserved.
//

import Foundation

internal extension Date {
    
    internal func toGMT() -> Date {
        let timeZone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: NSInteger = -timeZone.secondsFromGMT(for: self)
        return self.addingTimeInterval(TimeInterval(seconds))
    }
    
    func dateByAddingDays(_ days: Int) -> Date {
        return (Calendar.current as NSCalendar)
            .date(
                byAdding: .day,
                value: days,
                to: self,
                options: []
            )!
    }
    
    func dateWithMinimumTimeComponents(_ calendar: Calendar) -> Date {
        let units: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
        var components: DateComponents = (calendar as NSCalendar).components(units, from: self)
        components.setValue(0, for: Calendar.Component.hour)
        components.setValue(0, for: Calendar.Component.minute)
        components.setValue(0, for: Calendar.Component.second)
        return calendar.date(from: components)!
    }
    
    func dateWithMaximumTimeComponents(_ calendar: Calendar) -> Date {
        let units: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
        var components: DateComponents = (calendar as NSCalendar).components(units, from: self)
        components.setValue(23, for: Calendar.Component.hour)
        components.setValue(59, for: Calendar.Component.minute)
        components.setValue(59, for: Calendar.Component.second)
        return calendar.date(from: components)!
    }
    
    func beginningOfWeek() -> Date {
        let calendar = (Locale.current as NSLocale).object(forKey: NSLocale.Key.calendar) as! Calendar
        //        let calendar = NSCalendar.currentCalendar()
        var components = (calendar as NSCalendar).components([.yearForWeekOfYear, .weekOfYear], from: self)
        components.hour = 12
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }
    
    func localTimeComponents() -> DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.autoupdatingCurrent
        return (calendar as NSCalendar).components([.hour, .minute, .second], from: self)
    }
    
    func SOQLDateString() -> String {
        let soqlDateFormatter = DateFormatter()
        soqlDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return soqlDateFormatter.string(from: self)
    }
}
