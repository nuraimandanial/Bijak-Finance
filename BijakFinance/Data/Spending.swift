//
//   Spending.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//   

import Foundation

enum SpendingType: String, CaseIterable {
    case commitment = "Commitments"
    case need = "Needs"
    case saving = "Savings"
    
    func rawValue() -> String {
        switch self {
        case .commitment:
            return "Commitments"
        case .need:
            return "Needs"
        case .saving:
            return "Savings"
        }
    }
    
    func transaction(amount: Double) -> String {
        let amountText = String(format: "%.2f", amount)
        
        switch self {
        case .commitment:
            return "RM \(amountText) deducted for Commitments"
        case .need:
            return "RM \(amountText) deducted for Needs"
        case .saving:
            return "RM \(amountText) added into Savings"
        }
    }
}

struct Spending {
    var type: SpendingType
    var amount: Double = 0
    var date = Date()
}

extension Spending {
    static let data = [
        Spending(type: .commitment, amount: 250),
        Spending(type: .need, amount: 470),
        Spending(type: .saving, amount: 580),
    ]
}

class Spendings: ObservableObject {
    @Published var spendings: [Spending]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spendings = try container.decode([Spending].self, forKey: .spendings)
    }
    
    init(spendings: [Spending]) {
        self.spendings = spendings
    }
    
    func addSpending(type: SpendingType, amount: Double) {
        if let index = spendings.firstIndex(where: { $0.type == type }) {
            spendings[index].amount += amount
        } else {
            spendings.append(Spending(type: type, amount: amount))
        }
        objectWillChange.send()
    }
    
    func totalSpending() -> Double {
        spendings.filter { $0.type != .saving }.reduce(0) { $0 + $1.amount }
    }
}

struct Transactions: Identifiable {
    var id = UUID()
    
    var date = Date()
    var content: String = ""
    var amount: Double = 0
}

extension SpendingType: Codable, Hashable {}
extension Spending: Codable, Hashable {}
extension Spendings: Codable, Hashable {
    enum CodingKeys: CodingKey {
        case spendings
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(spendings, forKey: .spendings)
    }
    
    static func == (lhs: Spendings, rhs: Spendings) -> Bool {
        return lhs.spendings == rhs.spendings
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(spendings)
    }
}
extension Transactions: Codable, Hashable {}
