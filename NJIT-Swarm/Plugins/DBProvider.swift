//
//  DBProvider.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 02/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias DataHandler = (_ data: [String: Any]?) -> Void

public class DBProvider {
    private static let _instance = DBProvider()
    public init () {}
    static var Instance: DBProvider {
        return _instance
    }
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var userRef: DatabaseReference {
        return dbRef.child(Constants.USER)
    }
    
    var checkinRef: DatabaseReference {
        return dbRef.child(Constants.CHECKIN)
    }
    
    func saveUser(withID: String, email: String, password: String, username: String, phone: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.USERNAME: username, Constants.PHONE: phone]
        userRef.child(withID).setValue(data)
    }
    
    func updateUserDate(data: Dictionary<String, Any>) {
        if let uid = AuthProvider.Instance.getUserID() {
            userRef.child(uid).updateChildValues(data)
        }
    }
    
    func setUserData(key: String, value: Any) {
        if let uid = AuthProvider.Instance.getUserID() {
            userRef.child(uid).child(key).setValue(value)
        }
    }
    
    /*
     Get user by uid
     
     Return data should be: [String: Any]
     Like [username: min, email: min@mail.com, ... ]
     */
    func getUserData(withID: String, dataHandler: DataHandler?) {
        userRef.child(withID).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    /*
     Search users by name, phone, etc.
     withKey: see "Constants.swift" keys for user
     
     Return data should be: [String: [String: Any]]
     Like [uid1: [username: min, email: min@mail.com, ... ], uid2: [username: asha, email: asha@mail.com, ...], ...]
     */
    func getUsers(withKey: String, value: Any, dataHandler: DataHandler?) {
        userRef.queryOrdered(byChild: withKey).queryEqual(toValue: value).observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    func sendRequest(senderId: String, receiverId: String) {
        userRef.child(receiverId).child(Constants.RECEIVE_REQUEST).child(senderId).setValue(true)
    }
    
    func saveFriend(withID: String, friendID: String) {
        userRef.child(withID).child(Constants.RECEIVE_REQUEST).child(friendID).removeValue()
        userRef.child(friendID).child(Constants.RECEIVE_REQUEST).child(withID).removeValue()
        
        userRef.child(withID).child(Constants.FRIENDS).child(friendID).setValue(true)
        userRef.child(friendID).child(Constants.FRIENDS).child(withID).setValue(true)
    }
    
    func getFriends(withID: String, dataHandler: DataHandler?) {
        userRef.child(withID).child(Constants.FRIENDS).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value {
//                print(snapshot)
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    func getAllUsers(dataHandler: DataHandler?) {
        userRef.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    func removeFriend(withID: String, friendID: String) {
        userRef.child(withID).child(Constants.FRIENDS).child(friendID).removeValue()
        userRef.child(friendID).child(Constants.FRIENDS).child(withID).removeValue()
    }
    
    func saveCheckin(withID: String, place: String, message: String, latitude: Double, longitude: Double, taggedUids: Array<String>?, rating: Float) {
        var data: Dictionary<String, Any> = [Constants.UID: withID, Constants.PLACE: place, Constants.MESSAGE: message, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude, Constants.TIMESTAMP: ServerValue.timestamp(), Constants.RATING: rating]
        if taggedUids != nil {
            var uidDic = Dictionary<String, Any>()
            for uid in taggedUids! {
                uidDic[uid] = true
            }
            data[Constants.TAGGEDUIDS] = uidDic
        }
        checkinRef.childByAutoId().setValue(data)
    }
    
    func getCheckins(dataHandler: DataHandler?) {
        checkinRef.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    func getCheckins(withID: String, dataHandler: DataHandler?) {
        checkinRef.queryOrdered(byChild: Constants.UID).queryEqual(toValue: withID).observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    func likeCheckin(withCheckinID: String, uid: String) {
        checkinRef.child(withCheckinID).child(Constants.LIKE).child(uid).setValue(true)
    }
    func unlikeCheckin(withCheckinID: String, uid: String) {
        checkinRef.child(withCheckinID).child(Constants.LIKE).child(uid).removeValue()
    }
    
    func saveComment(withCheckinID: String, uid: String, comment: String) {
        let data: Dictionary<String, Any> = [Constants.UID: uid, Constants.COMMENT: comment, Constants.TIMESTAMP: ServerValue.timestamp()]
        checkinRef.child(withCheckinID).child(Constants.COMMENT).childByAutoId().setValue(data)
    }
    
    func getComments(withCheckinID: String, dataHandler: DataHandler?) {
        checkinRef.child(withCheckinID).child(Constants.COMMENT).observeSingleEvent(of: .value) { (snapshot) in
        //    print(snapshot)
            if let value = snapshot.value {
                if let data = value as? [String: Any] {
                    dataHandler?(data)
                } else {
                    dataHandler?(nil)
                }
            } else {
                dataHandler?(nil)
            }
        }
    }
    
    func removeComment(withCheckinId: String, commentId: String) {
        checkinRef.child(withCheckinId).child(Constants.COMMENT).child(commentId).removeValue()
    }
    
} // class
