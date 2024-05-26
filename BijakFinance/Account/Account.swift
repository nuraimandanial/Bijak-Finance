//
//   Account.swift
//   BijakFinance
//
//   Created by @kinderBono on 07/05/2024.
//

import SwiftUI

struct Account: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var profile: Profile = .init()
    @State var budget: Double = 0
    @State var alert: Bool = false
    @State var deleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: profile.image)) { result in
                            switch result {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            case .failure(_):
                                if !profile.image.isEmpty {
                                    Image(profile.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else {
                                    Placeholder(width: 120, shape: .circle)
                                }
                            @unknown default:
                                fatalError()
                            }
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.whites)
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.blacks.opacity(0.3), lineWidth: 2)
                            HStack {
                                Text(profile.name)
                                    .padding()
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.whites)
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.blacks.opacity(0.3), lineWidth: 2)
                            HStack {
                                Text(appModel.authManager.auth.currentUser?.email ?? "")
                                    .padding()
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.whites)
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.blacks.opacity(0.3), lineWidth: 2)
                            HStack {
                                Text(String(repeating: "*", count: profile.password))
                                    .padding()
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.whites)
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.blacks.opacity(0.3), lineWidth: 2)
                            HStack {
                                Text("\(budget, format: .currency(code: "MYR"))")
                                    .padding()
                                Spacer()
                            }
                        }
                        .frame(height: 50)
                        HStack {
                            Text("Enable Notifications")
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 50, height: 30)
                                    .foregroundStyle(profile.allowNotification ? .green : .gray.opacity(0.5))
                                HStack {
                                    if profile.allowNotification {
                                        Spacer()
                                    }
                                    Circle()
                                        .frame(width: 27)
                                        .foregroundStyle(.white)
                                    if !profile.allowNotification {
                                        Spacer()
                                    }
                                }
                                .padding(2)
                            }
                            .frame(width: 50)
                        }
                    }
                    .padding()
                    
                    VStack {
                        NavigationLink(destination: {
                            EditProfile()
                                .environmentObject(appModel)
                        }, label: {
                            ZStack {
                                ButtonLabel(text: "Edit Profile")
                                    .padding(.horizontal, 40)
                            }
                        })
                        .alert(isPresented: $deleteAlert) {
                            Alert(title: Text("Delete Account"), message: Text("Are you sure to delete your account?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Confirm"), action: {
                                deleteAccount()
                            }))
                        }
                        Button(action: {
                            alert = true
                        }, label: {
                            ButtonLabel(text: "Sign Out", color: .red)
                                .padding(.horizontal, 40)
                        })
                        .alert(isPresented: $alert) {
                            Alert(title: Text("Log Out"), message: Text("Are you sure to sign out?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("OK"), action: {
                                signOut()
                            }))
                        }
                    }
                    Spacer().frame(height: 50)
                }
                .padding([.horizontal, .top])
            }
            .foregroundStyle(.blacks)
            .task {
                profile = appModel.dataManager.currentUser.profile
                budget = appModel.dataManager.currentUser.budget.reduce(0) { $0 + $1.amount }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: {
                            deleteAlert = true
                        }, label: {
                            HStack(spacing: 10) {
                                Image(systemName: "trash")
                                Text("Delete Account")
                            }
                            .foregroundStyle(.red)
                        })
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
        }
    }
    
    func signOut() {
        appModel.authManager.signOut { error in
            if let error = error {
                print("Error signing out: \(error.localizedDescription)")
            } else {
                appModel.dataManager.saveUser()
                appModel.selectedTab = 0
                appModel.isLoggedIn = false
                appModel.dataManager.currentUser = .init()
            }
        }
    }
    
    func deleteAccount() {
        appModel.authManager.deleteAccount { error in
            if let error = error {
                print("Error Deleting Account: \(error.localizedDescription)")
            } else {
                appModel.selectedTab = 0
                appModel.isLoggedIn = false
                appModel.dataManager.currentUser = .init()
            }
        }
    }
}

#Preview {
    Account()
        .environmentObject(AppModel())
}
