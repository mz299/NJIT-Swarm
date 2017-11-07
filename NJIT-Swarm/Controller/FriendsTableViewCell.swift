//
//  FriendsTableViewCell.swift
//  NJIT-Swarm
//
//  Created by Dhruvik Patel on 11/4/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: FriendData) {
        nameLabel.text = data.username
        emailLabel.text = data.email
        phoneLabel.text = data.phone
        if data.profile_image_url != "" {
            let url = URL(string: data.profile_image_url)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = image
                        }
                    }
                }
            }).resume()
        }
    }
}
