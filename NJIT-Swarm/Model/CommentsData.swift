//
//  CommentsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 05/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class CommentsData {
    private static let _instance = CommentsData()
    private init() {}
    static var Instance: CommentsData {
        return _instance
    }
    
    var _data = Array<CommentData>()
    var Data: Array<CommentData> {
        get {
            return _data
        }
    }
    
    func update(withCheckinId: String, handler: CommentDataHandler?) {
        _data.removeAll()
        DBProvider.Instance.getComments(withCheckinID: withCheckinId) { (commentsData) in
            if commentsData != nil {
                for commentData in commentsData! {
                    var newData = CommentData()
                    newData.commentid = commentData.key
                    newData.checkinid = withCheckinId
                    if let value = commentData.value as? [String: Any] {
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
                        if let timestamp = value[Constants.TIMESTAMP] as? Date {
                            newData.timestamp = timestamp
                        }
                    }
                    self._data.append(newData)
                }
            }
        }
        handler?(self._data)
    }
}
