//
//  CheckIn.swift
//  NJIT-Swarm
//
//  Created by Palash Bairagi on 11/6/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation

class CheckIn{
    var checkInkey: String
    var profilePictureName: String
    var name: String
    var dateAndTime: String
    var place: String
    var detail: String
    var rating: Double
    var likes: Int
    var comments: Int
    var isLiked: Bool
    
    
    init(key:String, profilePictureName: String, name: String, dateAndTime: String, place: String, detail: String, rating: Double, likes: Int, comments: Int, isLiked: Bool) {
        self.checkInkey = key
        self.name = name
        self.profilePictureName = profilePictureName
        self.dateAndTime = dateAndTime
        self.place = place
        self.detail = detail
        self.rating = rating
        self.likes = likes
        self.comments = comments
        self.isLiked = isLiked
    }
}
