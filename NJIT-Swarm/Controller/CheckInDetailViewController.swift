//
//  CheckInDetailViewController.swift
//  NJIT-Swarm
//
//  Created by Palash Bairagi on 11/26/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class CheckInDetailViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taggedFriendLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var checkInPicture: UIImageView!
    
    var checkInKey = ""
    var userKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkIn = CheckinsData.Instance.getCheckinData(byCheckinId: checkInKey)
        
        let taggedFriends = checkIn?.taggedUserIds
        if(taggedFriends?.count != 0)
        {
            var labelText = "With"
            for friendUID in taggedFriends! {
                let friendData = FriendsData.Instance.getData(uid: friendUID)
                let uName = friendData?.username
                labelText += " \(uName!)"
            }
            taggedFriendLabel.text = labelText
        }
        else
        {
            taggedFriendLabel.text = ""
        }
        
        if checkIn?.profile_image_url != "" {
            let url = URL(string: (checkIn?.profile_image_url)!)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            self.profilePicture.image = image
                        }
                    }
                }
            }).resume()
        }
        
        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 2
        self.profilePicture.clipsToBounds = true
        
        self.userKey = (checkIn?.uid)!
        self.nameButton.setTitle(checkIn?.username, for: UIControlState.normal)
        self.placeLabel.text = checkIn?.place
        self.reviewLabel.text = checkIn?.message
        self.ratingLabel.text = "\(checkIn?.rating ?? 0.0)"
        self.dateLabel.text = Global.convertTimestampToDateTime(timeInterval: (checkIn?.timestamp)!)
    }

    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
