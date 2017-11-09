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
    
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var uid: String = ""
    
    @IBAction func add(_ sender: Any) {
        addButton.isHidden = true
        addButton.isUserInteractionEnabled = false
        statusLabel.text = "Sent Request"
        statusLabel.isHidden = false
        
        let data = SearchFriendsData.Instance.Data[index]
//        DBProvider.Instance.saveFriend(withID: AuthProvider.Instance.getUserID()!, friendID: data.uid)
        DBProvider.Instance.sendRequest(senderId: AuthProvider.Instance.getUserID()!, receiverId: data.uid)
    }
    
    @IBAction func nameButtonClicked(_ sender: Any) {
        if(self.uid != ""){
            let historyViewController: HistoryViewController = HistoryViewController()
            historyViewController.uid = self.uid
            var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!;
            while ((topController.presentedViewController) != nil) {
                topController = topController.presentedViewController!;
            }
            topController.present(historyViewController, animated: false, completion: nil)
        }
    }
    
    func setData(data: FriendData) {
        self.uid = data.uid
        self.nameButton.setTitle(data.username, for: .normal)
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
            statusLabel.isHidden = false
        } else if sentRequest {
            addButton.isHidden = true
            addButton.isUserInteractionEnabled = false
            statusLabel.text = "Sent Request"
            statusLabel.isHidden = false
        } else if sentRequest == false {
            statusLabel.isHidden = true
            addButton.isHidden = false
            addButton.isUserInteractionEnabled = true
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
