//
//  Global.swift
//  NJIT-Swarm
//
//  Created by Palash Bairagi on 11/7/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import Foundation
public class Global{
    private static let _instance = Global()
    public init () {}
    static var Instance: Global {
        return _instance
    }
     static func convertTimestampToDateTime(timeInterval: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd HH:mm"
        let result = formatter.string(from: timeInterval as Date)
        return result
    }
    
}
