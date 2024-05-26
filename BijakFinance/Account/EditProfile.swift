//
//   EditProfile.swift
//   BijakFinance
//
//   Created by @kinderBono on 12/05/2024.
//   

import SwiftUI

struct EditProfile: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var profile: Profile = .init()
    @State var email: String = ""
    
    @State var image: UIImage?
    @State var showMediaPicker: Bool = false
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    @State var success: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        Button(action: {
                            showMediaPicker = true
                        }, label: {
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
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                    } else {
                                        Placeholder(width: 120, shape: .circle)
                                    }
                                @unknown default:
                                    fatalError()
                                }
                            }
                        })
                        .sheet(isPresented: $showMediaPicker) {
                            ImagePicker(image: $image)
                        }
                        Textbox(hint: "Name", text: $profile.name)
                        Textbox(hint: "Email", text: $email)
                            .disabled(true)
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.whites)
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.blacks.opacity(0.3), lineWidth: 2)
                            HStack {
                                if profile.password != 0 {
                                    Text(String(repeating: "*", count: profile.password))
                                } else {
                                    Text("Password")
                                        .foregroundStyle(.gray).opacity(0.5)
                                }
                                Spacer()
                            }
                            .padding(10)
                        }
                        .frame(height: 50)

                        Toggle(isOn: $profile.allowNotification) {
                            Text("Enable Notifications")
                        }
                    }
                    .padding()
                    Spacer()
                    VStack {
                        NavigationLink(destination: {
                            ChangePassword()
                                .environmentObject(appModel)
                        }, label: {
                            ButtonLabel(text: "Change Password")
                                .padding(.horizontal, 40)
                        })
                        Button(action: {
                            updateProfile()
                        }, label: {
                            ButtonLabel(text: "Update Profile", color: .yellows)
                                .padding(.horizontal, 40)
                        })
                        .alert(isPresented: $alert) {
                            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                                if success {
                                    dismiss()
                                }
                            }))
                        }
                    }
                    Spacer().frame(height: 50)
                }
                .padding([.horizontal, .top])
            }
            .foregroundStyle(.blacks)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.yellows)
                    })
                    Spacer()
                    Text("Edit Profile")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                }
            }
            .task {
                profile = appModel.dataManager.currentUser.profile
                email = appModel.authManager.auth.currentUser?.email ?? ""
            }
        }
    }
    
    func updateProfile() {
        appModel.dataManager.updateProfile(with: profile) { error in
            if let error = error {
                alertMessage = "Error Updating Profile: \(error.localizedDescription)"
            } else {
                if let image = image {
                    appModel.dataManager.uploadProfileImage(image: image) { result in
                        switch result {
                        case .success(let url):
                            alertMessage = "Profile Updated Successfully"
                            print(url)
                            success = true
                        case .failure(let error):
                            alertMessage = "Error Updating Profile: \(error.localizedDescription)"
                        }
                    }
                } else {
                    alertMessage = "Profile Updated Successfully"
                    success = true
                }
            }
            alert = true
        }
    }
}

#Preview {
    EditProfile()
        .environmentObject(AppModel())
}

struct ChangePassword: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    @State var showPassword: Bool = false
    
    @State var alert: Bool = false
    @State var alertMessage: String = ""
    @State var success: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        ZStack {
                            Textbox(hint: "Current Password", text: $currentPassword, fieldType: showPassword ? .text : .password)
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
                        .padding(.bottom, 10)
                        ZStack {
                            Textbox(hint: "New Password", text: $newPassword, fieldType: showPassword ? .text : .password)
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
                        ZStack {
                            Textbox(hint: "Confirm Password", text: $confirmPassword, fieldType: showPassword ? .text : .password)
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
                        updatePassword()
                    }, label: {
                        ButtonLabel(text: "Update Password", color: .yellows)
                    })
                    .alert(isPresented: $alert) {
                        Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                            if success {
                                dismiss()
                            }
                        }))
                    }
                    Spacer()
                }
                .padding([.horizontal, .top])
                .foregroundStyle(.blacks)
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.yellows)
                    })
                    Spacer()
                    Text("Change Password")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                }
            }
        }
    }
    
    func updatePassword() {
        guard newPassword == confirmPassword else {
            alertMessage = "Password Not Match!"
            alert = true
            return
        }
        
        appModel.dataManager.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { error in
            if let error = error {
                alertMessage = "Error Updating Password: \(error.localizedDescription)"
            } else {
                alertMessage = "Password Updated Successfully"
                success = true
            }
            alert = true
        }
    }
}
