//
//  TagFriendsViewController.swift
//  NJIT-Swarm
//
//  Created by Apoorva Reed on 11/8/17.
//  Copyright © 2017 Team4. All rights reserved.
//


import UIKit


class TagFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tagFriendId: String?
    
    func setTagFriendId(uid: String) {
        tagFriendId = uid
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendsData.Instance.Data.count
        
    }
    
    //@IBOutlet weak var searchTextfield: UITextField!
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseTagFriendCell", for: indexPath) as! tagFriendsvwTableViewCell
        //cell.index = indexPath.row
        let data = FriendsData.Instance.Data[indexPath.row]
        
        cell.setData(data: data, controller: self)
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
//    @IBOutlet weak var BackPressed: UIButton!
    
    @IBOutlet weak var searchTablevw: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackPressed(_ sender: UIButton) {
        print("test")
         performSegue(withIdentifier: "getTaggednames", sender: self)
    }
    @IBAction func Back(_ sender: UIBarButtonItem) {
      
        
//        performSegue(withIdentifier: "getTaggednames", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CheckinViewController
        print("below is the tagfriend id")
        print(tagFriendId!)
        destVC.taggedfriends = tagFriendId!
    }
    
//    @IBAction func search(_ sender: Any) {
//        if searchTextfield.text != "" {
//            SearchFriendsData.Instance.searchFriends(withKey: Constants.EMAIL, value: searchTextfield.text!, handler: { (friends) in
//                self.searchTablevw.reloadData()
//            })
//        }
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

