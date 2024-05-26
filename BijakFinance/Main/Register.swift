//
//   Register.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//

import SwiftUI

struct Register: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    @State var success: Bool = false
    
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
                                .font(.title3)
                                .bold()
                        }
                        
                        VStack(spacing: 20) {
                            Text("Register")
                                .font(.title2)
                                .bold()
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .font(.title3)
                                    .bold()
                                Textbox(hint: "Name", text: $name)
                            }
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
                                register()
                            }, label: {
                                ButtonLabel(text: "Sign Up")
                            })
                            .alert(isPresented: $alert) {
                                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                                    if success {
                                        dismiss()
                                    }
                                }))
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    HStack {
                        Text("Already have an Account?")
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Log In")
                                .foregroundStyle(.teal)
                        })
                    }
                    .padding()
                }
                .padding()
            }
            .foregroundStyle(.blacks)
            .navigationBarBackButtonHidden()
        }
    }
    
    func register() {
        appModel.authManager.signUp(email: email, password: password, name: name) { error in
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "Regisration Successful: \(email)"
                success = true
            }
            alert = true
        }
    }
}

#Preview {
    Register()
        .environmentObject(AppModel())
}
