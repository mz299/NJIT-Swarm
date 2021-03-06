//
//  HistoryViewController.swift
//  NJIT-Swarm
//
//  Created by Palash Bairagi on 11/8/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var uid: String = ""
    var checkInsData: [CheckinData] = [CheckinData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        timelineTableView.register(nib, forCellReuseIdentifier: "timelineCell")
    }

    func loadUserData(){
        let userData = FriendsData.Instance.getData(uid: uid)
        self.userName.text = userData?.username
        let url = URL(string: (userData?.profile_image_url)!)
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
        
        self.profilePicture.layer.cornerRadius =  self.profilePicture.frame.size.height / 2
        self.profilePicture.clipsToBounds = true
        
        checkInsData = CheckinsData.Instance.getCheckinsData(byUid: uid)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkInsData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimelineTableViewCell
        
        let checkIn = checkInsData[indexPath.row]
        
        let url = URL(string: checkIn.profile_image_url)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            cell.profilePicture.image = image
                        }
                    }
                }
            }).resume()
        
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2
        cell.profilePicture.clipsToBounds = true
        
        let taggedFriends = checkIn.taggedUserIds
        if(taggedFriends.count != 0)
        {
            var labelText = "With"
            for friendUID in taggedFriends {
                let friendData = FriendsData.Instance.getData(uid: friendUID)
                let uName = friendData?.username
                labelText += " \(uName!)"
            }
            cell.taggedFriendLabel.text = labelText
        }
        else
        {
            cell.taggedFriendLabel.text = ""
        }
        
        cell.userKey = checkIn.uid
        cell.name.setTitle(checkIn.username, for: UIControlState.normal)
        cell.place.text = checkIn.place
        cell.detail.text = checkIn.message
        cell.rating.text = "\(checkIn.rating)"
        cell.commentCountButton.setTitle("\(checkIn.numofcomment)", for: UIControlState.normal)
        cell.dateTimeLabel.text = Global.convertTimestampToDateTime(timeInterval: checkIn.timestamp)
        cell.likeCountButton.setTitle("\(checkIn.numoflike)", for: UIControlState.normal)
        cell.checkInKey = checkIn.checkinid
        cell.isLiked = checkIn.youliked
        
        if(checkIn.youliked){
            cell.likeButton.tintColor = UIColor.red
        }
        else{
            cell.likeButton.tintColor = UIColor.gray
        }
        
        if(indexPath.row % 2 == 0){
            let red = Double((0xFF0000) >> 16) / 256.0
            let green = Double((0xCC00) >> 8) / 256.0
            let blue = Double((0x76)) / 256.0
            
            cell.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 0.5)
        }
        else{
            let red = Double((0xFF0000) >> 16) / 256.0
            let green = Double((0xAA00) >> 8) / 256.0
            let blue = Double((0x16)) / 256.0
            
            cell.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 0.5)
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.timelineTableView.cellForRow(at: indexPath) as! TimelineTableViewCell
        
        if(cell.checkInKey != ""){
            let checkInDetail: CheckInDetailViewController = CheckInDetailViewController()
            checkInDetail.checkInKey = cell.checkInKey
            var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!;
            while ((topController.presentedViewController) != nil) {
                topController = topController.presentedViewController!;
            }
            topController.present(checkInDetail, animated: false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CheckinsData.Instance.update(handler: {(checkins) in
            self.loadUserData()
            self.timelineTableView.reloadData()
        })
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
