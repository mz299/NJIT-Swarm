//
//  SearchFriendsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 04/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

/*
 struct FriendData {
 var uid = ""
 var username = ""
 var phone = ""
 var email = ""
 }
 */

class SearchFriendsData {
    private static let _instance = SearchFriendsData()
    private init() {}
    static var Instance: SearchFriendsData {
        return _instance
    }
    
    private var _data = Array<FriendData>()
    var Data: Array<FriendData> {
        get {
            return _data
        }
    }
    
    func searchFriends(withKey: String, value: String, handler: FriendDataHandler?) {
        _data.removeAll()
        DBProvider.Instance.getUsers(withKey: withKey, value: value) { (friendsData) in
            if friendsData != nil {
                for d in friendsData! {
                    var newData = FriendData()
                    newData.uid = d.key
                    if let fData = d.value as? [String: Any] {
                        if let email = fData[Constants.EMAIL] as? String {
                            newData.email = email
                        }
                        if let name = fData[Constants.USERNAME] as? String {
                            newData.username = name
                        }
                        if let phone = fData[Constants.PHONE] as? String {
                            newData.phone = phone
                        }
                    }
                    self._data.append(newData)
                }
            }
            handler?(self._data)
        }
    }
}
