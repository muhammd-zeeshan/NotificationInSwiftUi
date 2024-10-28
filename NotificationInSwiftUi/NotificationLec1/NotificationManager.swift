//
//  NotificationManager.swift
//  NotificationInSwiftUi
//
//  Created by Muhammad Zeeshan on 25/10/2024.
//

import Foundation
import NotificationCenter

@MainActor                                                                                //MARK: 2nd Tutorial Time Interval Notification
class NotificationManager: NSObject, ObservableObject { // if you want to show notification when the app is on foreground declare a class with the type NSObject and "UNUserNotificationCenterDelegate"
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted = false
    
    // storing pending request in publisher // 2nd Tutorial feature
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    // 4th Tutorial Practice feature
    @Published var nextView: NextView?
    
    // after declare class withe type of delegate now initialize the init // 2nd Tutorial feature
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentStattus()
    }
    
    func getCurrentStattus() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    // MARK: 2nd tutorial paractice Time Interval Notification
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        if let subTitle = localNotification.subTitle {
            content.subtitle = subTitle
        }
        if let bundleImageName = localNotification.bundleImageName,
           let url = Bundle.main.url(forResource: bundleImageName, withExtension: ""),
           let attachment = try? UNNotificationAttachment(identifier: bundleImageName, url: url) {
            content.attachments = [attachment]
        }
        if let userInfo = localNotification.userInfo {
            content.userInfo = userInfo
        }
        content.sound = .default
        
        if localNotification.schedule == .time{
            guard let timeInterval = localNotification.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = localNotification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        
        await getPendingRequests()
    }
    
    // get pending request of notification
    func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
        print("Pending requests: \(pendingRequests.count)")
    }
    
    // deleting pending request
    func removePendingRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequests.remove(at: index)
        }
        print(pendingRequests.count)
    }
}


extension NotificationManager: UNUserNotificationCenterDelegate {
    
    // Updated delegate function: with this function and declare manager class with "UNUserNotificationCenterDelegate" the notification is showing when the app is on foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        if let value = response.notification.request.content.userInfo["nextView"] as? String {
            nextView = NextView(rawValue: value)
        }
    }
    
}
