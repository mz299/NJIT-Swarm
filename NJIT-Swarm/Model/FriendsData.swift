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
                if usersData != nil {
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
                            } else {
                                newData.profile_image_url = Constants.DEFAULT_PROFILE_IMAGE_URL
                            }
                            if let receives = data[Constants.RECEIVE_REQUEST] as? [String: Any] {
                                newData.receive_request_uid = self.getKeys(data: receives)
                            }
                            if let allow_tag = data[Constants.ALLOW_TAG] as? Bool {
                                newData.allow_tag = allow_tag
                            }
                            if let allow_track = data[Constants.ALLOW_TRACK] as? Bool {
                                newData.allow_track = allow_track
                            }
                            if let show_phone = data[Constants.SHOW_PHONE] as? Bool {
                                newData.show_phone = show_phone
                            }
                            if let show_email = data[Constants.SHOW_EMAIL] as? Bool {
                                newData.show_email = show_email
                            }
                            if let notifications = data[Constants.NOTIFICATION] as? [String: Any] {
                                newData.notifications = self.getNotification(data: notifications)
                            }
                            if let latitude = data[Constants.LATITUDE] as? Double {
                                newData.latitude = latitude
                            }
                            if let longitude = data[Constants.LONGITUDE] as? Double {
                                newData.longitude = longitude
                            }
                        }
                        self._allUserData.append(newData)
                        if friendsData != nil {
                            for fData in friendsData! {
                                if uData.key == fData.key {
                                    self._data.append(newData)
                                }
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
    
    func getCurrentUserData() -> FriendData? {
        return _userdata
    }
    
    func getFriendIds() -> Array<String> {
        var uids = Array<String>()
        for data in _data {
            uids.append(data.uid)
        }
        return uids
    }
    
    private func getKeys(data: [String: Any]) -> Array<String> {
        var keys = Array<String>()
        for d in data {
            keys.append(d.key)
        }
        return keys
    }
    
    private func getNotification(data: [String: Any]) -> Array<NotificationData> {
        var notifications = Array<NotificationData>()
        for d in data {
            var nData = NotificationData()
            nData.id = d.key
            if let nd = d.value as? [String: Any] {
                if let msg = nd[Constants.NOTIFICATION_MSG] as? String {
                    nData.msg = msg
                }
                if let date = nd[Constants.NOTIFICATION_DATE] as? TimeInterval {
                    nData.date = Date(timeIntervalSince1970: date/1000)
                }
                if let isRead = nd[Constants.NOTIFICATION_ISREAD] as? Bool {
                    nData.isRead = isRead
                }
            }
            notifications.append(nData)
        }
        notifications.sort { (data1, data2) -> Bool in
            if data1.date.timeIntervalSince1970 > data2.date.timeIntervalSince1970 {
                return true
            } else {
                return false
            }
        }
        return notifications
    }
}
