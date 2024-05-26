//
//   Folder.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//   

import Foundation

struct Receipt: Identifiable {
    var id = UUID()
    
    var itemImage: String = ""
    var url: String = ""
    var amount: Double = 0
}

extension Receipt {
    static let receipts = [
        Receipt(itemImage: "receipt-1", amount: 0),
        Receipt(itemImage: "receipt-1", amount: 10),
        Receipt(itemImage: "receipt-1", amount: 5.6),
    ]
}

struct FolderItem: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var receipts: [Receipt] = []
    var amount: Double {
        receipts.reduce(0) { $0 + $1.amount }
    }
}

extension FolderItem {
    static let item = [
        FolderItem(name: "Lifestyle", receipts: Receipt.receipts),
        FolderItem(name: "Medical", receipts: Receipt.receipts)
    ]
    static let defaults = [
        FolderItem(name: "Lifestyle"),
        FolderItem(name: "Insurance"),
        FolderItem(name: "Education"),
        FolderItem(name: "Personal Sport Equipments"),
        FolderItem(name: "Breastfeeding Equipments"),
        FolderItem(name: "Books"),
        FolderItem(name: "Medical"),
        FolderItem(name: "Personal Devices"),
        FolderItem(name: "Travels"),
        FolderItem(name: "Tertiary Education")
    ]
}

extension Receipt: Codable, Hashable {}
extension FolderItem: Codable, Hashable {}
