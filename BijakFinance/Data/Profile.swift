//
//   Profile.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//   

import SwiftUI

struct User: Identifiable {
    var id: UUID {
        profile.id
    }
    var authId: String = ""
    
    var profile = Profile()
    var savings: Double {
        spendings.spendings.first(where: { $0.type == .saving })?.amount ?? 0
    }
    var spendings = Spendings(spendings: [])
    var budget: [Spending] = []
    var totalBudget: Double {
        budget.filter { $0.type != .saving }.reduce(0) { $0 + $1.amount }
    }
    var currentSpending: Double = 0
    var transaction: [String: [Transactions]] = ["Savings": [], "Spendings": []]
    
    var folders: [FolderItem] = FolderItem.defaults
    
    var notifications: [Notifications] = []
}

extension User {
    static let user = User(
        profile: Profile(name: "User 1", allowNotification: true),
        spendings: Spendings(spendings: Spending.data),
        budget: [
            Spending(type: .commitment, amount: 5000 * 0.35),
            Spending(type: .need, amount: 5000 * 0.45),
            Spending(type: .saving, amount: 5000 * 0.2)
        ],
        transaction: [
            "Savings": [
                Transactions(content: "Add to Savings", amount: 100),
                Transactions(content: "Add to Savings", amount: 128),
            ],
            "Spendings": [
                Transactions(content: "Commitment", amount: 560),
                Transactions(content: "Needs", amount: 100),
                Transactions(content: "Needs", amount: 120),
            ]
        ],
        notifications: Notifications.allNotifications
    )
}

struct Profile: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var password: Int = 0
    var image: String = "person"
    var allowNotification: Bool = false
}

extension User: Codable, Hashable {}
extension Profile: Codable, Hashable {}
