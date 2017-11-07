//
//  CheckinsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 03/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class CheckinsData {
    private static let _instance = CheckinsData()
    private init() {}
    static var Instance: CheckinsData {
        return _instance
    }
    
    var _data = Array<CheckinData>()
    var Data: Array<CheckinData> {
        get {
            return _data
        }
    }
    
    // get all friends and current user's checkins data
    func update(handler: CheckinDataHandler?) {
        _data.removeAll()
        DBProvider.Instance.getCheckins { (checkinsData) in
            if checkinsData != nil {
                for checkinData in checkinsData! {
                    if let cData = checkinData.value as? [String: Any] {
                        for fData in FriendsData.Instance.Data {
                            if let cUid = cData[Constants.UID] as? String {
                                if cUid == fData.uid || cUid == AuthProvider.Instance.getUserID() {
                                    var uData = FriendData()
                                    if cUid == fData.uid {
                                        uData = fData
                                    } else if cUid == AuthProvider.Instance.getUserID() {
                                        uData = FriendsData.Instance.UserData
                                    }
                                    var newData = CheckinData()
                                    newData.checkinid = checkinData.key
                                    if let latitude = cData[Constants.LATITUDE] as? Double {
                                        newData.latitude = latitude
                                    }
                                    if let longitute = cData[Constants.LONGITUDE] as? Double {
                                        newData.longitute = longitute
                                    }
                                    if let place = cData[Constants.PLACE] as? String {
                                        newData.place = place
                                    }
                                    if let uid = cData[Constants.UID] as? String {
                                        newData.uid = uid
                                    }
                                    if let message = cData[Constants.MESSAGE] as? String {
                                        newData.message = message
                                    }
                                    if let timestamp = cData[Constants.TIMESTAMP] as? TimeInterval {
                                        newData.timestamp = Date(timeIntervalSince1970: timestamp/1000)
                                    }
                                    if let numoflike = cData[Constants.LIKE] as? [String: Any] {
                                        newData.numoflike = numoflike.count
                                        for like in numoflike {
                                            if like.key == AuthProvider.Instance.getUserID() {
                                                newData.youliked = true
                                                break
                                            }
                                        }
                                    }
                                    if let numofcomment = cData[Constants.COMMENT] as? [String: Any] {
                                        newData.numofcomment = numofcomment.count
                                    }
                                    newData.username = uData.username
                                    newData.profile_image_url = uData.profile_image_url
                                    
                                    self._data.append(newData)
                                }
                            }
                        }
                    }
                }
            }
            handler?(self._data)
        }
    }
}
