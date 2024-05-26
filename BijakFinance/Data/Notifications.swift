//
//   Notification.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//   

import Foundation

struct Notifications: Identifiable {
    var id = UUID()
    
    var title: String
    var date: Date
    var message: String
    var unread: Bool = true
    
    mutating func read() {
        unread = false
    }
}

extension Notifications {
    static let allNotifications: [Notifications] = [
        Notifications(title: "Budget Overrun",
                      date: Date(timeIntervalSinceNow: -86400 * 1), // 1 day ago
                      message: "You have exceeded your weekly budget for dining out."),
        Notifications(title: "Transaction Alert",
                      date: Date(timeIntervalSinceNow: -86400 * 2), // 2 days ago
                      message: "A new transaction of RM500 was recorded at TechGadgets Store."),
        Notifications(title: "Payment Due",
                      date: Date(timeIntervalSinceNow: -86400 * 3), // 3 days ago
                      message: "Your credit card payment is due in 5 days."),
        Notifications(title: "Transaction Alert",
                      date: Date(timeIntervalSinceNow: -86400 * 3), // 3 days ago
                      message: "A new transaction of RM370 was recorded at All IT Store."),
        Notifications(title: "Budget Update",
                      date: Date(timeIntervalSinceNow: -86400 * 5), // 5 days ago
                      message: "Your monthly budget has been updated. Review your limits to stay on track.")
    ]
}

struct NotificationGroup {
    var date: Date
    var notifications: [Notifications]
}

extension NotificationGroup {
    static func group(_ notifications: [Notifications]) -> [NotificationGroup] {
        let groupedDictionary = Dictionary(grouping: notifications, by: { Calendar.current.startOfDay(for: $0.date) })
        return groupedDictionary.map { NotificationGroup(date: $0.key, notifications: $0.value) }.sorted { $0.date > $1.date }
    }
}

extension Notifications: Codable, Hashable {}
extension NotificationGroup: Codable, Hashable {}

enum NotificationDisplay {
    case all, unread
}
