//
//   AuthManager.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//   

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    var auth = Auth.auth()
    private var firebaseServices = FirebaseServices()
    
    func signUp(email: String, password: String, name: String, completion: @escaping (Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else if let authResult = authResult {
                let uid = authResult.user.uid
                
                let profile = Profile(id: UUID(uuidString: uid) ?? UUID(), name: name, password: password.count)
                let newUser = User(authId: uid, profile: profile)
                
                guard let userData = try? JSONEncoder().encode(newUser), let jsonObject = try? JSONSerialization.jsonObject(with: userData), let jsonDict = jsonObject as? [String: Any] else {
                    completion(NSError(domain: "Data Encoding Error", code: 0, userInfo: nil))
                    return
                }
                
                self.firebaseServices.saveUser(userId: uid, jsonData: jsonDict) { error in
                    completion(error)
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                let uid = authResult.user.uid
                
                self.firebaseServices.fetchUser(userId: uid) { result in
                    completion(result)
                }
            }
        }
    }
    
    func reauntheticate(currentPassword: String, completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser, let email = user.email else {
            completion(NSError(domain: "User Not Logged In", code: 0, userInfo: nil))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { _, error in
            completion(error)
        }
    }
    
    func updatePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(NSError(domain: "User Not Logged In", code: 0, userInfo: nil))
            return
        }
        
        user.updatePassword(to: newPassword) { error in
            completion(error)
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let signOutError {
            completion(signOutError)
        }
    }
    
    func checkAuth(completion: @escaping (Bool) -> Void) {
        auth.addStateDidChangeListener { _, user in
            if let user = user {
                user.getIDTokenForcingRefresh(true) { token, error in
                    if let error = error {
                        print(error)
                        completion(false)
                    } else {
                        completion(token != nil)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func refreshIdToken() {
        guard let user = auth.currentUser else {
            return
        }
        
        user.getIDTokenForcingRefresh(true) { _, error in
            if let error = error {
                print("Error Refreshing Token: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAccount(completion: @escaping (Error?) -> Void) {
        guard let user = auth.currentUser else {
            completion(NSError(domain: "User Not Logged In", code: 0, userInfo: nil))
            return
        }
        
        firebaseServices.deleteUser(userId: user.uid) { [self] error in
            if let error = error {
                completion(error)
                return
            }
            
            firebaseServices.deleteUserStorage(userId: user.uid) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                user.delete { error in
                    completion(error)
                }
            }
        }
    }
}
