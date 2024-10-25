//
//  FirebaseImageManager.swift
//  Authentication
//
//  Created by Mit Patel on 18/10/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirebaseImageManager: ObservableObject {
    
    @Published var profileImage: UIImage?
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false

    private var storage = Storage.storage().reference()
    private var firestore = Firestore.firestore()

    init() {
        fetchProfileImage()
    }

    func fetchProfileImage() {
        DispatchQueue.global(qos: .background).async {
            if let cachedImageData = UserDefaults.standard.data(forKey: "profileImage") {
                DispatchQueue.main.async {
                    self.profileImage = UIImage(data: cachedImageData)
                }
            } else {
                self.loadImageFromFirebase()
            }
        }
    }

    private func loadImageFromFirebase() {
        let userID = Auth.auth().currentUser?.uid ?? "defaultUser"
        let imageRef = storage.child("profile_images/\(userID).jpg")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Error fetching image: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.profileImage = UIImage(data: data)
                    UserDefaults.standard.set(data, forKey: "profileImage")
                }
            }
        }
    }

    func updateProfileImage(newImage: UIImage) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let compressedData = self.compressImage(image: newImage) {
                let userID = Auth.auth().currentUser?.uid ?? "defaultUser"
                let imageRef = self.storage.child("profile_images/\(userID).jpg")
                
                imageRef.putData(compressedData, metadata: nil) { metadata, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.alertMessage = "Error uploading image: \(error.localizedDescription)"
                            self.showAlert = true
                        }
                        return
                    }
                    
                    // Get download URL and update Firestore
                    imageRef.downloadURL { url, error in
                        if let url = url {
                            self.updateFirestoreImageURL(userID: userID, imageURL: url.absoluteString)
                            DispatchQueue.main.async {
                                self.profileImage = newImage
                                UserDefaults.standard.set(compressedData, forKey: "profileImage")
                                self.alertMessage = "Image updated successfully."
                                self.showAlert = true
                            }
                        }
                    }
                }
            }
        }
    }

    func compressImage(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.7)
    }

    private func updateFirestoreImageURL(userID: String, imageURL: String) {
        firestore.collection("users").document(userID).updateData(["profileImageURL": imageURL]) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Error updating Firestore: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
}
