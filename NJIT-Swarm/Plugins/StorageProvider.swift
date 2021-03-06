//
//  StorageProvider.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 04/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit

typealias UploadHandler = (_ url: String?) -> Void
typealias DownloadHandler = (_ data: Data?) -> Void

class StorageProvider {
    private static let _instance = StorageProvider()
    private init() {}
    static var Instance: StorageProvider {
        return _instance
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://njit-swarm-2.appspot.com/")
    }
   
    var userRef: StorageReference {
        return storageRef.child(Constants.USER)
    }
    var checkInRef: StorageReference {
        return storageRef.child(Constants.CHECKIN)
    }
    
    func uploadProfilePic(image: Data?, uid: String, handler: UploadHandler?) {
        userRef.child("\(uid).jpg").putData(image!, metadata: nil) { (metadata, error) in
            if error != nil {
                handler?(nil)
            } else {
                handler?(metadata?.downloadURL()?.absoluteString)
            }
        }
    }
    
    func uploadCheckinPic(image: Data?, checkinId: String, handler: UploadHandler?) {
        checkInRef.child("\(checkinId).jpg").putData(image!, metadata: nil) { (metadata, error) in
            if error != nil {
                handler?(nil)
            } else {
                handler?(metadata?.downloadURL()?.absoluteString)
            }
        }
    }
    
    
    func downloadProfilePicUrl(uid: String) {
        
    }
}
