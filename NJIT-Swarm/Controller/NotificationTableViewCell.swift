//
//  NotificationTableViewCell.swift
//  NJIT-Swarm
//
//  Created by Palash Bairagi on 11/26/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!

    var notificationKey = "";
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if(notificationKey != "")
        {
            DBProvider.Instance.removeNotification(withUid: AuthProvider.Instance.getUserID()!, noticationId: self.notificationKey)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationDeleted"), object: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
