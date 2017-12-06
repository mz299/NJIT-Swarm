//
//  FriendsViewController.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 03/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit
import FirebaseDatabase
class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let ADD_FRIEND_SEGUE = "addFriend"
    
    private var requestData = Array<FriendData>()
    
    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

//    let people = [String]()
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Friend Requests"
        }
        return "Friends"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let data = FriendsData.Instance.getData(uid: AuthProvider.Instance.getUserID()!) {
                requestData = FriendsData.Instance.getUsersData(byUids: data.receive_request_uid)
                return requestData.count
            } else {
                return 0
            }
        }
        return FriendsData.Instance.Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseFriendsCell", for: indexPath) as! FriendsTableViewCell
        if indexPath.section == 0 {
            let data = requestData[indexPath.row]
            cell.setData(data: data, section: indexPath.section)
        }
        else if indexPath.section == 1 {
            let data = FriendsData.Instance.Data[indexPath.row]
            cell.setData(data: data, section: indexPath.section)
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
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        /*FriendsData.Instance.update { (friends) in
            friendTableView.reloadData()
        }

        // Do any additional setup after loading the view.
        friendTableView.delegate = self
        friendTableView.dataSource = self
        
        //set firebase reference
        ref = Database.database().reference()
        //retrieve users and listen for changes
        databaseHandle = ref?.child("user").observe(.childAdded, with: { (snapshot) in
            //code to execute when a child is addd
            //take data from snapshot ad add to user/people array
            let post = snapshot.value as? String
            if let actualPost = post {
                self.people.append(actualPost)
                //reload
                self.friendTableView.reloadData()
            }
        })*/
        
        FriendsData.Instance.update { (friends) in
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addFriend(_ sender: Any) {
        performSegue(withIdentifier: ADD_FRIEND_SEGUE, sender: nil)
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
