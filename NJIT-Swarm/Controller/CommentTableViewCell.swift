//
//  CommentTableViewCell.swift
//  foursquare-swarm
//
//  Created by Palash Bairagi on 11/4/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
   
    var checkInKey: String = ""
    var commentKey: String = ""
    var row: Int = 0
    var commentsTableView: UITableView? = nil
    var commentsData: [CommentData] = [CommentData()]
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if(checkInKey != "" && commentKey != "")
        {
        DBProvider.Instance.removeComment(withCheckinId: checkInKey, commentId: commentKey)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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
