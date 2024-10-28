//
//  LocalNotification.swift
//  NotificationInSwiftUi
//
//  Created by Muhammad Zeeshan on 25/10/2024.
//

import Foundation


struct LocalNotification {
    
    internal init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
        self.schedule = .time
        self.identifier = identifier
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    internal init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
        self.schedule = .calendar
        self.identifier = identifier
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    enum scheduleType {
        case time, calendar
    }
    
    var schedule: scheduleType
    var identifier: String
    var title: String
    var body: String
    var subTitle: String?
    var bundleImageName: String?
    var userInfo: [AnyHashable : Any]?
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
}
