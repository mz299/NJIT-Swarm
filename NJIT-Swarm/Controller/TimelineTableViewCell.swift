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
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var place: UILabel!
    
    var checkInKey: String = ""
    var isLiked: Bool = false
    
    @IBAction func nameButtonClicked(_ sender: Any) {
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        if(self.isLiked){
            DBProvider.Instance.unlikeCheckin(withCheckinID: self.checkInKey, uid: AuthProvider.Instance.getUserID()!)
            self.isLiked = false
            self.likeButton.tintColor = UIColor.gray
            let count = Int(self.likeCountButton.currentTitle!)
            self.likeCountButton.setTitle("\(String(describing: count!-1))", for: .normal)
        }
        else{
            DBProvider.Instance.likeCheckin(withCheckinID: self.checkInKey, uid: AuthProvider.Instance.getUserID()!)
            self.isLiked = true
            self.likeButton.tintColor = UIColor.red
            let count = Int(self.likeCountButton.currentTitle!)
            self.likeCountButton.setTitle("\(String(describing: count!+1))", for: .normal)
        }

    }
    
    @IBAction func likeCountButtonClicked(_ sender: Any) {
        let likesViewController = LikesViewController()
        likesViewController.checkInKey = self.checkInKey
        var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!;
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
       topController.present(likesViewController, animated: false, completion: nil)
    }
    
    @IBAction func commentCountButtonClicked(_ sender: Any) {
        let commentViewController = CommentViewController()
        commentViewController.checkInKey = self.checkInKey
        var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!;
        while ((topController.presentedViewController) != nil) {
            topController = topController.presentedViewController!;
        }
        topController.present(commentViewController, animated: false, completion: nil)
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
