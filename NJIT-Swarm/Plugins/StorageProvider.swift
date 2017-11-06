//
//  StorageProvider.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 04/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation
import FirebaseStorage

typealias UploadHandler = (_ url: String?) -> Void
typealias DownloadHandler = (_ data: Data?) -> Void

class StorageProvider {
    private static let _instance = StorageProvider()
    private init() {}
    static var Instance: StorageProvider {
        return _instance
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://njit-swarm.appspot.com/")
    }
    var userRef: StorageReference {
        return storageRef.child(Constants.USER)
    }
    var placeRef: StorageReference {
        return storageRef.child(Constants.PLACE)
    }
    
    func uploadProfilePic(image: Data?, uid: String, handler: UploadHandler?) {
        userRef.child("\(uid).png").putData(image!, metadata: nil) { (metadata, error) in
            if error != nil {
                handler?(nil)
            } else {
                handler?(metadata?.downloadURL()?.absoluteString)
            }
        }
    }
    
    func getProfilePicUrl(uid: String) -> String {
        return userRef.child("\(uid).png").fullPath
    }
    
    func downloadProfilePicUrl(uid: String) {
        
    }
}
