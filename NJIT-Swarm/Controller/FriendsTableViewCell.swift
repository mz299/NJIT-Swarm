//
//  FriendsTableViewCell.swift
//  NJIT-Swarm
//
//  Created by Dhruvik Patel on 11/4/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    var uid: String = ""
    
    private var friendData = FriendData()
    private var addedFriend = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    @IBAction func add(_ sender: Any) {
        if addedFriend {
            DBProvider.Instance.removeFriend(withID: AuthProvider.Instance.getUserID()!, friendID: friendData.uid)
        } else {
            DBProvider.Instance.saveFriend(withID: AuthProvider.Instance.getUserID()!, friendID: friendData.uid)
        }
//        addButton.isHidden = true
        addButton.setTitleColor(UIColor.darkGray, for: .normal)
        addButton.isUserInteractionEnabled = false
    }
    
    func setData(data: FriendData, section: Int) {
        friendData = data
        self.uid = data.uid
        self.nameButton.setTitle(data.username, for: .normal)
        emailLabel.text = data.email
        phoneLabel.text = data.phone
        if section == 1 {
//            addButton.isHidden = false
//            addButton.isUserInteractionEnabled = true
            addButton.setTitle("Remove", for: .normal)
            addedFriend = true
        } else if section == 0 {
//            addButton.isHidden = false
//            addButton.isUserInteractionEnabled = true
            addedFriend = false
        }
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
