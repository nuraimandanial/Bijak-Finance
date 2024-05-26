//
//   Login.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//   

import SwiftUI

struct Login: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    VStack(spacing: 40) {
                        VStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                            Text("Bijak Finance")
                                .font(.title2)
                                .bold()
                        }
                        
                        VStack(spacing: 20) {
                            Text("Log In")
                                .font(.title)
                                .bold()
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .font(.title3)
                                    .bold()
                                Textbox(hint: "Email", text: $email)
                            }
                            VStack(alignment: .leading) {
                                Text("Password")
                                    .font(.title3)
                                    .bold()
                                ZStack {
                                    Textbox(hint: "Password", text: $password, fieldType: showPassword ? .text : .password)
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            showPassword.toggle()
                                        }, label: {
                                            Image(systemName: showPassword ? "eye" : "eye.slash")
                                        })
                                    }
                                    .padding()
                                }
                            }
                            Button(action: {
                                login()
                            }, label: {
                                ButtonLabel(text: "Login")
                            })
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                    
                    HStack {
                        Text("Don't have any Account?")
                        NavigationLink(destination: {
                            Register()
                        }, label: {
                            Text("Sign Up")
                                .foregroundStyle(.teal)
                        })
                    }
                    .padding()
                }
                .padding()
            }
            .foregroundStyle(.blacks)
        }
    }
    
    func login() {
        appModel.authManager.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                appModel.isLoggedIn = true
                appModel.dataManager.currentUser = user
            case .failure(let error):
                alertMessage = "Login Failed: \(error.localizedDescription)"
            }
            alert = true
        }
    }
}

#Preview {
    Login()
        .environmentObject(AppModel())
}
