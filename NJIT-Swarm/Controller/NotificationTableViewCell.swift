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
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
    
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
