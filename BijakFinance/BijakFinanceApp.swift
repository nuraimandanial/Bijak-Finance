//
//  BijakFinanceApp.swift
//  BijakFinance
//
//  Created by Nina Ashakila on 07/05/2024.
//

import SwiftUI
import Firebase

@main
struct BijakFinanceApp: App {
    @StateObject var appModel = AppModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.init(Color.whites)
        UITabBar.appearance().unselectedItemTintColor = UIColor.init(Color.yellows.opacity(0.5))
        UITabBar.appearance().barTintColor = UIColor.init(Color.whites)
        
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if appModel.isLoggedIn {
                ContentView()
                    .environmentObject(appModel)
            } else {
                Login()
                    .environmentObject(appModel)
            }
        }
        .environment(\.colorScheme, .light)
    }
}
