//
//   FirebaseServices.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//   

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine

class FirebaseServices {
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func saveUser(userId: String, jsonData: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).setData(jsonData) { error in
            completion(error)
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let document = document, document.exists, let data = document.data() {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let user = try JSONDecoder().decode(User.self, from: jsonData)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No user data found", code: 404, userInfo: nil)))
            }
        }
    }
    
    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image Conversion Error", code: -1, userInfo: nil)))
            return
        }
        
        let storageRef = storage.reference()
        let imagePath = "\(userId)/profilePicture/\(UUID().uuidString).jpg"
        let imageRef = storageRef.child(imagePath)
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadUrl = url {
                    completion(.success(downloadUrl.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "Unknown Error", code: -2, userInfo: nil)))
                }
            }
        }
    }
    
    func uploadReceipt(userId: String, category: String, itemImage: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Image Conversion Error", code: -1, userInfo: nil)))
            return
        }
        
        let storageRef = storage.reference()
        let imagePath = "\(userId)/receipts/\(category)/\(itemImage).jpg"
        let imageRef = storageRef.child(imagePath)
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadUrl = url {
                    completion(.success(downloadUrl.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "Unknown Error", code: -2, userInfo: nil)))
                }
            }
        }
    }
    
    func deleteReceipt(withUrl url: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference(forURL: url)
        storageRef.delete { error in
            completion(error)
        }
    }
    
    func deleteUser(userId: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).delete { error in
            completion(error)
        }
    }
    
    func deleteUserStorage(userId: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference().child(userId)
        
        storageRef.listAll { (result, error) in
            guard let result = result else {
                completion(NSError(domain: "Error Getting Storage List", code: 0, userInfo: nil))
                return
            }
            if let error = error {
                completion(error)
                return
            }
            
            let deleteGroup = DispatchGroup()
            for item in result.items {
                deleteGroup.enter()
                item.delete { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    deleteGroup.leave()
                }
            }
            
            for prefix in result.prefixes {
                deleteGroup.enter()
                prefix.delete { error in
                    if let error = error{
                        completion(error)
                        return
                    }
                    deleteGroup.leave()
                }
            }
            
            deleteGroup.notify(queue: .main) {
                completion(nil)
            }
        }
    }
}
