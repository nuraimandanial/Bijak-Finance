//
//   Tax.swift
//   BijakFinance
//
//   Created by @kinderBono on 10/05/2024.
//   

import Foundation

enum Category: CaseIterable {
    case individual, child, parent, other
    
    func rawValue() -> String {
        switch self {
        case .individual:
            return "Individual / Spouse"
        case .child:
            return "Child"
        case .parent:
            return "Parent"
        case .other:
            return "Other"
        }
    }
}

struct TaxCategory: Identifiable {
    var id = UUID()
    var name: String
    var category: Category
    var limit: Double
    var amount: Double = 0
    var isSaved: Bool = false
}

extension TaxCategory {
    static let categories = [
        TaxCategory(name: "Individual", category: .individual, limit: 9000, amount: 9000, isSaved: true),
        TaxCategory(name: "Disabled Individual", category: .individual, limit: 6000),
        TaxCategory(name: "Spouse Payment", category: .individual, limit: 4000),
        TaxCategory(name: "Disabled Spouse", category: .individual, limit: 5000),
        
        TaxCategory(name: "Breastfeeding Equipment", category: .child, limit: 1000),
        TaxCategory(name: "Child Care", category: .child, limit: 3000),
        TaxCategory(name: "SSPN (Child Education Saving)", category: .child, limit: 3000),
        TaxCategory(name: "Unmarried Child <18y/o", category: .child, limit: 2000),
        TaxCategory(name: "Unmarried Child >18y/o (Education)", category: .child, limit: 10000),
        TaxCategory(name: "Disabled Child", category: .child, limit: 8000),
        
        TaxCategory(name: "Medical Treatment (Parents)", category: .parent, limit: 8000),
        
        TaxCategory(name: "Supporting Equipment", category: .other, limit: 6000),
        TaxCategory(name: "Education Fees (Self)", category: .other, limit: 7000),
        TaxCategory(name: "Medical Expenses (Self/Spouse/Child)", category: .other, limit: 10000),
        TaxCategory(name: "Lifestyle", category: .other, limit: 3000),
        TaxCategory(name: "Life Insurance", category: .other, limit: 7000),
        TaxCategory(name: "Annuity / PRS", category: .other, limit: 3000),
        TaxCategory(name: "Education and Medical Insurance", category: .other, limit: 3000),
        TaxCategory(name: "SOCSO / PERKESO", category: .other, limit: 350),
        TaxCategory(name: "EPF / KWSP", category: .other, limit: 4000),
        TaxCategory(name: "EV Charging Expenses", category: .other, limit: 2500),
    ]
}

struct TaxRate: Identifiable {
    var id = UUID()
    
    var limit: Double
    var rate: Double
    var maximum: Double
    var previousTax: Double = 0
}

struct TaxAmountInfo: Identifiable {
    var id = UUID()
    var text: String
    var amount: Double
}

extension Category: Codable, Hashable {}
extension TaxCategory: Codable, Hashable {}
extension TaxRate: Codable, Hashable {}
extension TaxAmountInfo: Codable, Hashable {}
