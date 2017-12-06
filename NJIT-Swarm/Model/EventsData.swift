//
//  EventsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 01/12/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class EventsData {
    private static let _instance = EventsData()
    private init() {}
    static var Instance: EventsData {
        return _instance
    }
    
    var _data = Array<EventData>()
    var Data: Array<EventData> {
        get {
            return _data
        }
    }
    
    var _allData = Array<EventData>()
    var AllData: Array<EventData> {
        get {
            return _allData
        }
    }
    
    func update(handler: EventDateHandler?) {
        _data.removeAll()
        _allData.removeAll()
        DBProvider.Instance.getEvent { (events) in
            if events != nil {
                for event in events! {
                    if let data = event.value as? [String: Any] {
                        var newData = EventData()
                        newData.eventId = event.key
                        if let name = data[Constants.EVENT_NAME] as? String {
                            newData.eventname = name
                        }
                        if let location = data[Constants.EVENT_LOCATION] as? String {
                            newData.location = location
                        }
                        if let description = data[Constants.EVENT_DESCRIPTION] as? String {
                            newData.description = description
                        }
                        if let start = data[Constants.EVENT_START] as? TimeInterval {
                            newData.startDate = Date(timeIntervalSince1970: start)
                        }
                        if let end = data[Constants.EVENT_END] as? TimeInterval {
                            newData.endDate = Date(timeIntervalSince1970: end)
                        }
                        if let uid = data[Constants.UID] as? String {
                            newData.uid = uid
                        }
                        if let uData = FriendsData.Instance.getData(uid: newData.uid) {
                            newData.username = uData.username
                        }
                        if let joinIds = data[Constants.EVENT_JOIN] as? [String: Any] {
                            newData.joinIds = self.getKeys(data: joinIds)
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
                if data1.startDate.timeIntervalSince1970 > data2.startDate.timeIntervalSince1970 {
                    return true
                } else {
                    return false
                }
            })
            self._data.sort(by: { (data1, data2) -> Bool in
                if data1.startDate.timeIntervalSince1970 > data2.startDate.timeIntervalSince1970 {
                    return true
                } else {
                    return false
                }
            })
            handler?(self._data)
        }
    }
    
    private func getKeys(data: [String: Any]) -> Array<String> {
        var keys = Array<String>()
        for d in data {
            keys.append(d.key)
        }
        return keys
    }
}
