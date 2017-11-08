//
//  DataStructure.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 04/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

struct CheckinData {
    var checkinid = ""
    var place = ""
    var latitude = Double()
    var longitute = Double()
    var uid = ""
    var timestamp = Date()
    var message = ""
    var username = ""
    var profile_image_url = ""
    var numoflike = 0
    var numofcomment = 0
    var youliked = false
    var likedUserIds = Array<String>()
    var taggedUserIds = Array<String>()
    var comments = Array<CommentData>()
}

typealias CheckinDataHandler = (_ data: Array<CheckinData>) -> Void

struct CommentData {
    var commentid = ""
    var checkinid = ""
    var uid = ""
    var username = ""
    var profile_image_url = ""
    var timestamp = Date()
    var comment = ""
}

typealias CommentDataHandler = (_ data: Array<CommentData>) -> Void

struct FriendData {
    var uid = ""
    var username = ""
    var phone = ""
    var email = ""
    var profile_image_url = ""
    var receive_request_uid = Array<String>()
}

typealias FriendDataHandler = (_ data: Array<FriendData>) -> Void
