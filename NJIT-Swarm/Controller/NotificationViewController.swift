//
//  NotificationViewController.swift
//  NJIT-Swarm
//
//  Created by Palash Bairagi on 11/26/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        notificationTable.register(nib, forCellReuseIdentifier: "notificationCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "notificationDeleted"), object: nil)
    }
    
    @objc func loadList(){
        FriendsData.Instance.update{ (friends) in
            self.notificationTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount: Int =  0
        if(FriendsData.Instance.getCurrentUserData() != nil)
        {
            rowCount = FriendsData.Instance.getCurrentUserData()!.notifications.count
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        let notificationData: NotificationData = FriendsData.Instance.getCurrentUserData()!.notifications[indexPath.row]
        
        if (!notificationData.isRead){
            let red = Double((0x040000) >> 16) / 256.0
            let green = Double((0x3300) >> 8) / 256.0
            let blue = Double((0xFF)) / 256.0
            
            cell.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 0.05)
        }
        else if(indexPath.row % 2 == 0){
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
        
        cell.notificationKey = notificationData.id
        cell.messageLabel.text = "\(notificationData.msg)"
        cell.dateTimeLabel.text = Global.convertTimestampToDateTime(timeInterval: notificationData.date)
        
        DBProvider.Instance.setNotification(isRead: true, uid: AuthProvider.Instance.getUserID()!, notificationId: notificationData.id)
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.getUserID() != nil {
            FriendsData.Instance.update{ (friends) in
                self.notificationTable.reloadData()
            }
        }
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
