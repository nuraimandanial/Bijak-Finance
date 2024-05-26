//
//  ContentView.swift
//  BijakFinance
//
//  Created by @kinderBono on 07/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    
    var tabs: [TabItem] = [
        TabItem(view: AnyView(Home()), name: "Home", icon: "house"),
        TabItem(view: AnyView(Budget()), name: "Budget", icon: "plus.circle"),
        TabItem(view: AnyView(TaxCalculator()), name: "Calculator", icon: "percent"),
        TabItem(view: AnyView(ReceiptFolder()), name: "Folder", icon: "folder"),
        TabItem(view: AnyView(Account()), name: "Account", icon: "person"),
    ]
    
    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            ForEach(tabs.indices, id: \.self) { index in
                NavigationStack {
                    tabs[index].view
                        .environmentObject(appModel)
                        .toolbar {
                            Toolbar(text: tabs[index].name, image: appModel.dataManager.currentUser.profile.image)
                        }
                }.tag(index)
                .tabItem { Label(tabs[index].name, systemImage: tabs[index].icon) }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppModel())
}

struct TabItem {
    var view: AnyView
    var name: String
    var icon: String
}
