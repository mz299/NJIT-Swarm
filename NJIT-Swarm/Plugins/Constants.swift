//
//  Constants.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 02/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class Constants {
    // DBProvider
    static let DEFAULT_PROFILE_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/njit-swarm-2.appspot.com/o/user%2Fdefault.png?alt=media&token=7d5d60f3-2bee-48a9-ad19-1552dfd01cf0"
    // Keys for user
    static let USER = "user"
    static let EMAIL = "email"
    static let PASSWORD = "password"
    static let USERNAME = "username"
    static let PHONE = "phone"
    static let FRIENDS = "friends"
    static let PROFILE_IMAGE_URL = "profile_image_url"
    static let RECEIVE_REQUEST = "receive_request"
    static let ALLOW_TAG = "allow_tag"
    static let ALLOW_TRACK = "allow_track"
    static let SHOW_PHONE = "show_phone"
    static let SHOW_EMAIL = "show_email"
    
    // Keys for notification
    static let NOTIFICATION = "notification"
    static let NOTIFICATION_MSG = "msg"
    static let NOTIFICATION_DATE = "date"
    static let NOTIFICATION_ISREAD = "isread"
    
    // Keys for check in
    static let CHECKIN = "checkin"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let PLACE = "place"
    static let TIMESTAMP = "timestamp"
    static let UID = "uid"
    static let MESSAGE = "message"
    static let COMMENT = "comment"
    static let LIKE = "like"
    static let TAGGEDUIDS = "taggeduids"
    static let RATING = "rating"
    static let CHECKIN_IMAGE_URL = "checkin_image_url"
    // Keys for place
    
    // Keys for event
    static let EVENT = "event"
    static let EVENT_NAME = "eventname"
    static let EVENT_LOCATION = "location"
    static let EVENT_DESCRIPTION = "description"
    static let EVENT_START = "start"
    static let EVENT_END = "end"
}
