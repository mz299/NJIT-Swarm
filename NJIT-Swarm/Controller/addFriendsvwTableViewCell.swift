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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func add(_ sender: Any) {
        addButton.isHidden = true
        addButton.isUserInteractionEnabled = false
        statusLabel.text = "Sent Request"
        
        let data = SearchFriendsData.Instance.Data[index]
//        DBProvider.Instance.saveFriend(withID: AuthProvider.Instance.getUserID()!, friendID: data.uid)
        DBProvider.Instance.sendRequest(senderId: AuthProvider.Instance.getUserID()!, receiverId: data.uid)
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
        
        var sentRequest = false
        for uid in data.receive_request_uid {
            if uid == AuthProvider.Instance.getUserID() {
                sentRequest = true
            }
        }
        
        if FriendsData.Instance.getFriendData(uid: data.uid) != nil {
            addButton.isHidden = true
            addButton.isUserInteractionEnabled = false
            statusLabel.text = "Added"
        } else if sentRequest {
            addButton.isHidden = true
            addButton.isUserInteractionEnabled = false
            statusLabel.text = "Sent Request"
        } else {
            statusLabel.isHidden = true
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
