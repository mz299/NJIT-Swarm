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
                            newData.likedUserIds = self.getLikedIds(data: likes)
                            for like in likes {
                                if like.key == AuthProvider.Instance.getUserID() {
                                    newData.youliked = true
                                    break
                                }
                            }
                        }
                        if let comments = cData[Constants.COMMENT] as? [String: Any] {
                            newData.numofcomment = comments.count
                            newData.comments = self.getCommentsData(data: comments, checkinId: checkinData.key)
                        }
                        
                        if let uData = FriendsData.Instance.getData(uid: newData.uid) {
                            newData.username = uData.username
                            newData.profile_image_url = uData.profile_image_url
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
            handler?(self._data)
        }
    }
    
    func getCheckinData(uid: String) -> CheckinData? {
        for data in _data {
            if data.uid == uid {
                return data
            }
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
        return commentsData
    }
    private func getLikedIds(data: [String: Any]) -> Array<String> {
        var likedIds = Array<String>()
        for lData in data {
            likedIds.append(lData.key)
        }
        return likedIds
    }
}
