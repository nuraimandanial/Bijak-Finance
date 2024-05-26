//
//   DataManager.swift
//   BijakFinance
//
//   Created by @kinderBono on 08/05/2024.
//   

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    private var firebaseServices = FirebaseServices()
    private var authManager = AuthManager()
    
    @Published var users: [User] = []
    @Published var currentUser: User = User() {
        didSet {
            saveCurrentUser()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "currentUserKey"
    
    init() {
        loadCurrentUser()
    }
    
    public func saveCurrentUser() {
        do {
            let encodedData = try JSONEncoder().encode(currentUser)
            userDefaults.set(encodedData, forKey: currentUserKey)
            authManager.refreshIdToken()
        } catch {
            print("Error Encoding Current User: \(error)")
        }
    }
    
    private func loadCurrentUser() {
        guard let savedData = userDefaults.data(forKey: currentUserKey) else {
            return
        }
        
        do {
            let loadedUser = try JSONDecoder().decode(User.self, from: savedData)
            currentUser = loadedUser
            authManager.refreshIdToken()
        } catch {
            print("Error Decoding Current User: \(error)")
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        authManager.reauntheticate(currentPassword: currentPassword) { [self] error in
            if let error = error {
                completion(error)
            } else {
                authManager.updatePassword(newPassword: newPassword) { error in
                    completion(error)
                }
                currentUser.profile.password = newPassword.count
                saveUser()
            }
        }
    }
    
    func updateProfile(with profile: Profile, completion: @escaping (Error?) -> Void) {
        let userId = currentUser.authId
        
        currentUser.profile = profile
        
        guard let userData = try? JSONEncoder().encode(currentUser), let jsonObject = try? JSONSerialization.jsonObject(with: userData), let jsonDict = jsonObject as? [String: Any] else {
            completion(NSError(domain: "Data Encoding Error", code: 0, userInfo: nil))
            return
        }
        
        firebaseServices.saveUser(userId: userId, jsonData: jsonDict) { error in
            completion(error)
        }
    }
    
    func saveUser() {
        let userId = currentUser.authId
        
        guard let userData = try? JSONEncoder().encode(currentUser), let jsonObject = try? JSONSerialization.jsonObject(with: userData), let jsonDict = jsonObject as? [String: Any] else {
            return
        }
        
        firebaseServices.saveUser(userId: userId, jsonData: jsonDict) { _ in }
        saveCurrentUser()
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let userId = currentUser.authId
        
        firebaseServices.uploadProfileImage(userId: userId, image: image) { [self] result in
            switch result {
            case .success(let url):
                currentUser.profile.image = url
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteBudgetSummary() {
        currentUser.budget = []
        currentUser.currentSpending = 0
        saveUser()
    }
    
    func addSpending(type: SpendingType, amount: Double) {
        currentUser.spendings.addSpending(type: type, amount: amount)
        currentUser.transaction[type != .saving ? "Spendings" : "Savings"]?.append(Transactions(content: type.transaction(amount: amount), amount: amount))
        if type != .saving {
            self.currentUser.currentSpending += amount
        }
        saveUser()
    }
    
    func addReceipt(category: String, itemImage: String, image: UIImage, amount: Double, completion: @escaping (Result<String, Error>) -> Void) {
        let userId = currentUser.authId
        
        firebaseServices.uploadReceipt(userId: userId, category: category, itemImage: itemImage, image: image) { [self] result in
            switch result {
            case .success(let url):
                let receipt = Receipt(itemImage: itemImage, url: url, amount: amount)
                if let index = currentUser.folders.firstIndex(where: { $0.name == category }) {
                    currentUser.folders[index].receipts.append(receipt)
                    saveUser()
                    
                    completion(.success(url))
                } else {
                    let error = NSError(domain: "Data Manager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Category Not Found"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteReceipt(fromCategory category: String, withUrl url: String, completion: @escaping (Bool, Error?) -> Void) {
        if let folderIndex = currentUser.folders.firstIndex(where: { $0.name == category }) {
            if let receiptIndex = currentUser.folders[folderIndex].receipts.firstIndex(where: { $0.url == url }) {
                currentUser.folders[folderIndex].receipts.remove(at: receiptIndex)
                
                firebaseServices.deleteReceipt(withUrl: url) { [self] error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        saveUser()
                        completion(true, nil)
                    }
                }
            } else {
                let error = NSError(domain: "Data Manager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Receipt Not Found"])
                completion(false, error)
            }
        } else {
            let error = NSError(domain: "Data Manager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Category Not Found"])
            completion(false, error)
        }
    }
}
