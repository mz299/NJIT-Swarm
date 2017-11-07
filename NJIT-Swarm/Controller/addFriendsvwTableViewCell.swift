//
//  addFriendsvwTableViewCell.swift
//  NJIT-Swarm
//
//  Created by Asha Vatalia on 11/4/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class addFriendsvwTableViewCell: UITableViewCell {
    private var _index = 0
    var index: Int {
        get {
            return _index
        }
        set {
            _index = newValue
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBAction func add(_ sender: Any) {
        let data = SearchFriendsData.Instance.Data[index]
        DBProvider.Instance.saveFriend(withID: AuthProvider.Instance.getUserID()!, friendID: data.uid)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
