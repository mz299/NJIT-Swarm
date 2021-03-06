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
    var rating = Float()
    var checkin_image_url = ""
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
    var allow_tag = true
    var allow_track = true
    var show_phone = true
    var show_email = true
    var notifications = Array<NotificationData>()
    var latitude = 0.0 as Double
    var longitude = 0.0 as Double
}

typealias FriendDataHandler = (_ data: Array<FriendData>) -> Void

struct EventData {
    var eventId = ""
    var eventname = ""
    var location = ""
    var description = ""
    var startDate = Date()
    var endDate = Date()
    var uid = ""
    var username = ""
    var joinIds = Array<String>()
}

typealias EventDateHandler = (_ date: Array<EventData>) -> Void

struct NotificationData {
    var id = ""
    var msg = ""
    var date = Date()
    var isRead = false
}
