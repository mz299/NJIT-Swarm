//
//  UserCheckinsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 04/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

/*
 struct CheckinData {
 var place = ""
 var latitude = Double()
 var longitute = Double()
 var uid = ""
 var timestamp = Date()
 var message = ""
 var username = ""
 }
 */

class UserCheckinsData {
    private static let _instance = UserCheckinsData()
    private init() {}
    static var Instance: UserCheckinsData {
        return _instance
    }
    
    var _data = Array<CheckinData>()
    var Data: Array<CheckinData> {
        get {
            return _data
        }
    }
    
    // get a single user's checkins data
    func getUserCheckinsData(withID: String, handler: CheckinDataHandler?) {
        _data.removeAll()
        DBProvider.Instance.getUserData(withID: withID) { (userData) in
            if userData != nil {
                DBProvider.Instance.getCheckins(withID: withID) { (checkinsData) in
                    if checkinsData != nil {
                        for checkinData in checkinsData! {
                            if let cData = checkinData.value as? [String: Any] {
                                var newData = CheckinData()
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
                                if let timestamp = cData[Constants.TIMESTAMP] as? Date {
                                    newData.timestamp = timestamp
                                }
                                if let username = userData![Constants.USERNAME] as? String {
                                    newData.username = username
                                }
                                self._data.append(newData)
                            }
                        }
                    }
                    handler?(self._data)
                }
            }
        }
    }
    
}
