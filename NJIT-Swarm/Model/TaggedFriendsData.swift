//
//  TaggedFriendsData.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 21/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class TaggedFriendsData {
    private static let _instance = TaggedFriendsData()
    private init() {}
    static var Instance: TaggedFriendsData {
        return _instance
    }
    
    private var _uids = Array<String>()
    var UIDs: Array<String> {
        get {
            return _uids
        }
    }
    
    func clean() {
        _uids.removeAll()
    }
    
    func addUID(uid: String) {
        _uids.append(uid)
    }
    
    func setUIDs(uids: Array<String>) {
        _uids = uids
    }
}
