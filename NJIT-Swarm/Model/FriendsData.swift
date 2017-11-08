//
//  FriendsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 03/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class FriendsData {
    private static let _instance = FriendsData()
    private init() {}
    static var Instance: FriendsData {
        return _instance
    }
    
    private var _data = Array<FriendData>()
    var Data: Array<FriendData> {
        get {
            return _data
        }
    }
    
    private var _userdata = FriendData()
    var UserData: FriendData {
        get {
            return _userdata
        }
    }
    
    private var _allUserData = Array<FriendData>()
    var AllUserData: Array<FriendData> {
        get {
            return _allUserData
        }
    }
    
    func update(handler: FriendDataHandler?) {
        _data.removeAll()
        _allUserData.removeAll()
        _userdata = FriendData()
        DBProvider.Instance.getAllUsers { (usersData) in
            DBProvider.Instance.getFriends(withID: AuthProvider.Instance.getUserID()!, dataHandler: { (friendsData) in
                if usersData != nil && friendsData != nil {
                    for uData in usersData! {
                        var newData = FriendData()
                        newData.uid = uData.key
                        if let data = uData.value as? [String: Any] {
                            if let email = data[Constants.EMAIL] as? String {
                                newData.email = email
                            }
                            if let name = data[Constants.USERNAME] as? String {
                                newData.username = name
                            }
                            if let phone = data[Constants.PHONE] as? String {
                                newData.phone = phone
                            }
                            if let url = data[Constants.PROFILE_IMAGE_URL] as? String {
                                newData.profile_image_url = url
                            }
                        }
                        self._allUserData.append(newData)
                        for fData in friendsData! {
                            if uData.key == fData.key {
                                self._data.append(newData)
                            }
                        }
                        if uData.key == AuthProvider.Instance.getUserID()! {
                            self._userdata = newData
                        }
                    }
                }
                handler?(self._data)
            })
        }
    }
    
    func getData(uid: String) -> FriendData? {
        for data in _allUserData {
            if data.uid == uid {
                return data
            }
        }
        return nil
    }
    
    func getUsersData(byUids: Array<String>) -> Array<FriendData> {
        var usersData = Array<FriendData>()
        for uid in byUids {
            for uData in _allUserData {
                if uid == uData.uid {
                    usersData.append(uData)
                }
            }
        }
        return usersData
    }
    
    func getFriendData(uid: String) -> FriendData? {
        for data in _data {
            if data.uid == uid {
                return data
            }
        }
        return nil
    }
}
