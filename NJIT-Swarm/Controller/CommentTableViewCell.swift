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
    var commentsTableView: UITableView? = nil
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        DBProvider.Instance.removeComment(withCheckinId: checkInKey, commentId: commentKey)
        CheckinsData.Instance.update(handler: nil)
        self.commentsTableView?.reloadData()
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
