//
//  TimelineTableViewCell.swift
//  foursquare-swarm
//
//  Created by Palash Bairagi on 10/28/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        print("like button clicked at index", (sender as AnyObject).tag);
    }
    
    @IBAction func likeCountButtonClicked(_ sender: Any) {
        print("like count button clicked at index",(sender as AnyObject).tag)
        let likesViewController = LikesViewController()
        self.window?.rootViewController?.present(likesViewController, animated: true, completion: nil)
    }
    
    @IBAction func commentCountButtonClicked(_ sender: Any) {
        print("Comment Button Clicked at index", (sender as AnyObject).tag)
        let commentViewController = CommentViewController()
        self.window?.rootViewController?.present(commentViewController, animated: true, completion:nil)
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
