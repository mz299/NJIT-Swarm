//
//  CommentViewController.swift
//  foursquare-swarm
//
//  Created by Palash Bairagi on 11/4/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    var checkInKey: String = ""
    var commentsData: [CommentData] = [CommentData()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentButton.isEnabled = false
        self.commentButton.setTitleColor(UIColor.gray, for: .normal)
        self.setNotificationKeyboard()
        
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentsTableView.register(nib, forCellReuseIdentifier: "commentsCell")
        
        commentsData = CheckinsData.Instance.getComments(byCheckinId: checkInKey)!
    }

    // Notification when keyboard show
    func setNotificationKeyboard ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextField.endEditing(true)
        return false
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentButtonClicked(_ sender: Any) {
        
        var commentData: CommentData = CommentData()
        commentData.uid = AuthProvider.Instance.getUserID()!
        commentData.timestamp = Date()
        commentData.comment = self.commentTextField.text!
        
        let friendData = FriendsData.Instance.getData(uid: commentData.uid)
        let name = friendData?.username
        let profilePicURL = friendData?.profile_image_url
        
        commentData.profile_image_url = profilePicURL!
        commentData.username = name!
        
        commentsData.append(commentData)
        
        DBProvider.Instance.saveComment(withCheckinID: checkInKey, uid: commentData.uid, comment: commentData.comment)
        self.commentTextField.endEditing(true)
        self.commentTextField.text = ""
        self.textFieldDidChanged(sender)
        
        self.commentsTableView.reloadData()
    }
    
    @IBAction func textFieldDidChanged(_ sender: Any) {
        if(self.commentTextField.text == "")
        {
            self.commentButton.isEnabled = false
            self.commentButton.setTitleColor(UIColor.gray, for: .normal)
        }
        else
        {
            self.commentButton.isEnabled = true
            self.commentButton.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentTableViewCell
        
        let commentData: CommentData = commentsData[indexPath.row]
        
        let uid = commentData.uid
        let dateTime = commentData.timestamp
        let comment = commentData.comment
        
        if(uid == AuthProvider.Instance.getUserID())
        {
            cell.deleteButton.setTitle("Delete", for: UIControlState.normal)
        }
        else
        {
            cell.deleteButton.setTitle("", for: UIControlState.normal)
        }
        
        let friendData = FriendsData.Instance.getData(uid: uid)
        let name = friendData?.username
        let profilePicURL = friendData?.profile_image_url
        
        if profilePicURL != "" {
            let url = URL(string: profilePicURL!)
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
        }
        
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2
        cell.profilePicture.clipsToBounds = true
        
        cell.row = indexPath.row
        cell.commentsData = self.commentsData
        
        cell.commentKey = commentData.commentid
        cell.checkInKey = self.checkInKey
        cell.name.setTitle(name, for: UIControlState.normal)
        cell.dateTimeLabel.text = Global.convertTimestampToDateTime(timeInterval: dateTime)
        cell.commentLabel.text = comment
        
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
        
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
