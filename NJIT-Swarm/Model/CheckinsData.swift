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
    var _allData = Array<CheckinData>()
    var AllData: Array<CheckinData> {
        get {
            return _allData
        }
    }
    
    // get all friends and current user's checkins data
    func update(handler: CheckinDataHandler?) {
        _data.removeAll()
        _allData.removeAll()
        DBProvider.Instance.getCheckins { (checkinsData) in
            if checkinsData != nil {
                for checkinData in checkinsData! {
                    if let cData = checkinData.value as? [String: Any] {
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
                        if let likes = cData[Constants.LIKE] as? [String: Any] {
                            newData.numoflike = likes.count
                            newData.likedUserIds = self.getKeys(data: likes)
                            for like in likes {
                                if like.key == AuthProvider.Instance.getUserID() {
                                    newData.youliked = true
                                    break
                                }
                            }
                        }
                        if let taggedUids = cData[Constants.TAGGEDUIDS] as? [String: Any] {
                            newData.taggedUserIds = self.getKeys(data: taggedUids)
                        }
                        if let comments = cData[Constants.COMMENT] as? [String: Any] {
                            newData.numofcomment = comments.count
                            newData.comments = self.getCommentsData(data: comments, checkinId: checkinData.key)
                        }
                        
                        if let uData = FriendsData.Instance.getData(uid: newData.uid) {
                            newData.username = uData.username
                            newData.profile_image_url = uData.profile_image_url
                        }
                        if let rating = cData[Constants.RATING] as? Float {
                            newData.rating = rating
                        }
                        if let url = cData[Constants.CHECKIN_IMAGE_URL] as? String {
                            newData.checkin_image_url = url
                        }
                        
                        self._allData.append(newData)
                        
                        if FriendsData.Instance.getFriendData(uid: newData.uid) != nil {
                            self._data.append(newData)
                        }
                        if newData.uid == AuthProvider.Instance.getUserID() {
                            self._data.append(newData)
                        }
                        
                    }
                }
            }
            self._allData.sort(by: { (data1, data2) -> Bool in
                if data1.timestamp.timeIntervalSince1970 > data2.timestamp.timeIntervalSince1970 {
                    return true
                } else {
                    return false
                }
            })
            self._data.sort(by: { (data1, data2) -> Bool in
                if data1.timestamp.timeIntervalSince1970 > data2.timestamp.timeIntervalSince1970 {
                    return true
                } else {
                    return false
                }
            })
            handler?(self._data)
        }
    }
    
    func getCheckinsData(byUid: String) -> Array<CheckinData> {
        var checkinsData = Array<CheckinData>()
        for data in _allData {
            if data.uid == byUid {
                checkinsData.append(data)
            }
        }
        return checkinsData
    }
    
    func getCheckinData(byCheckinId: String) -> CheckinData? {
        for data in _allData {
            if data.checkinid == byCheckinId {
                return data
            }
        }
        return nil
    }
    
    func getComments(byCheckinId: String) -> Array<CommentData>? {
        if let checkinData = getCheckinData(byCheckinId: byCheckinId) {
            return checkinData.comments
        }
        return nil
    }
    
    func getLikedUserIds(byCheckinId: String) -> Array<String>? {
        if let checkinData = getCheckinData(byCheckinId: byCheckinId) {
            return checkinData.likedUserIds
        }
        return nil
    }
    
    private func getCommentsData(data: [String: Any], checkinId: String) -> Array<CommentData> {
        var commentsData = Array<CommentData>()
        for cData in data {
            var newData = CommentData()
            newData.commentid = cData.key
            newData.checkinid = checkinId
            if let value = cData.value as? [String: Any] {
                if let uid = value[Constants.UID] as? String {
                    newData.uid = uid
                    if let uData = FriendsData.Instance.getData(uid: uid) {
                        newData.profile_image_url = uData.profile_image_url
                    }
                }
                if let username = value[Constants.USERNAME] as? String {
                    newData.username = username
                }
                if let comment = value[Constants.COMMENT] as? String {
                    newData.comment = comment
                }
                if let timestamp = value[Constants.TIMESTAMP] as? TimeInterval {
                    newData.timestamp = Date(timeIntervalSince1970: timestamp/1000)
                }
            }
            commentsData.append(newData)
        }
        commentsData.sort { (data1, data2) -> Bool in
            if data1.timestamp.timeIntervalSince1970 > data2.timestamp.timeIntervalSince1970 {
                return true
            } else {
                return false
            }
        }
        return commentsData
    }
    
    private func getKeys(data: [String: Any]) -> Array<String> {
        var keys = Array<String>()
        for d in data {
            keys.append(d.key)
        }
        return keys
    }
}
