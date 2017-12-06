//
//  EventTableViewCell.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 01/12/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    private var eventData = EventData()
    private var joined = false
    
    @IBOutlet weak var labelEvent: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var buttonJoin: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(data: EventData) {
        eventData = data
        labelEvent.text = "Event: \(data.eventname)"
        labelLocation.text = "Location: \(data.location)"
        labelTime.text = "Time: \(Global.convertTimestampToDateTime(timeInterval: data.startDate))"
        textViewDescription.text = data.description
        
        for uids in eventData.joinIds {
            if AuthProvider.Instance.getUserID() == uids {
                joined = true
                buttonJoin.setTitle("Unjoin", for: .normal)
            }
        }
    }
    
    @IBAction func join(_ sender: Any) {
        if joined {
            DBProvider.Instance.unjoinEvent(withId: AuthProvider.Instance.getUserID()!, eventId: eventData.eventId)
            joined = false
            buttonJoin.setTitle("Join", for: .normal)
        } else {
            DBProvider.Instance.joinEvent(withId: AuthProvider.Instance.getUserID()!, eventId: eventData.eventId)
            joined = true
            buttonJoin.setTitle("Unjoin", for: .normal)
        }
    }
    
    
}
