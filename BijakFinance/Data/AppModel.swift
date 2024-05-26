//
//   AppModel.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//   

import Foundation
import SwiftUI

class AppModel: ObservableObject {
    @Published var dataManager = DataManager()
    @Published var authManager = AuthManager()
    
    @Published var selectedTab: Int = 0
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    private func checkAuthState() {
        authManager.checkAuth { [self] isAuthenticated in
            DispatchQueue.main.async {
                if isAuthenticated {
                    self.isLoggedIn = true
                } else {
                    self.isLoggedIn = false
                }
            }
        }
    }
}
