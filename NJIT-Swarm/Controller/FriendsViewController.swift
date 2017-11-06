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
    
    @IBOutlet weak var tableView: UITableView!
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    let people = [String]()
    @IBOutlet weak var friendTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendsData.Instance.Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseFriendsCell", for: indexPath) as! FriendsTableViewCell
        let data = FriendsData.Instance.Data[indexPath.row]
        cell.myImage.image = UIImage(named:"swarm.png")
        cell.myLabel.text = data.username
        
        
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
