//
//  TagFriendsViewController.swift
//  NJIT-Swarm
//
//  Created by Apoorva Reed on 11/8/17.
//  Copyright © 2017 Team4. All rights reserved.
//


import UIKit
import MapKit

class TagFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedPin:MKPlacemark? = nil
    var lattitude: Double? = nil
    var longitude: Double? = nil
    var titleName: String? = nil
    var locality: String? = nil
    var taggedfriends: String = ""
    var taggedfrienddata :String = ""
    var taggedFreindsUID = Array<String>()
    var Review: String = ""
    var Rating: Float = 4.0
    var checkinImage: Data? = nil
    var currentlocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
    
    func cleanVariables(){
        titleName = nil
    }
    
    @IBAction func CheckinTagFreinds(_ sender: UIButton) {
        
//        tagFriendId = "\(String(describing: tagFriendId))_"
        //let tagfrnddata = tagFriendId?.split(separator: "_")
        
        print(self.titleName)
        print(Review)
        print(self.lattitude)
        print(self.Rating)
        
        if self.titleName == nil || self.titleName == "" {
            let alert = UIAlertController(title: "Alert", message: "The location should not be empty.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "Confirm Checkin", message: "Would you like to Checkin?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            switch action.style{
                
            case .default:
                print("continue")
                
                let checkinId = DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: self.Review, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: self.taggedFreindsUID, rating: self.Rating)
                
                    let myName = FriendsData.Instance.getCurrentUserData()!.username
                DBProvider.Instance.saveNotification(withIds: self.taggedFreindsUID, msg: myName+" has tagged you")
                
                if let image = self.checkinImage {
                    StorageProvider.Instance.uploadCheckinPic(image: image, checkinId: checkinId, handler: { (url) in
                        DBProvider.Instance.saveCheckinImageUrl(checkinId: checkinId, url: url!)
                    })
                }
                
                // to do
                var friendCoordinate: CLLocation
                var distanceinMeters: Double
                
                let myselfLocation = CLLocation(latitude : self.lattitude!, longitude : self.longitude!)
                let frienddatas = FriendsData.Instance.Data
                var nearbyUserIds = Array<String>()
                for data in frienddatas
                {
                    // data.username
                    //data.latitude
                    //data.longitude
                    
                    if !data.allow_track {
                        continue
                    }
                    friendCoordinate  = CLLocation(latitude : data.latitude,longitude :  data.longitude)
                    distanceinMeters = myselfLocation.distance(from: friendCoordinate)
                    if(distanceinMeters<=8045){
                        nearbyUserIds.append(data.uid)
                    }
                    else{
                        
                    }
                    
                    // pin = pinAnnotation(title: data.username, subtitle: data.username, coordinate: friendlocation)
                    
                }
                let myname = FriendsData.Instance.getCurrentUserData()!.username
                DBProvider.Instance.saveNotification(withIds: nearbyUserIds, msg: "\(myname) checked in near you.")
                
                
                
                //                        }
                
                // to put data
                
            case .cancel:
                print("byebye")
            case .destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            switch action.style{
                
            case .default:
                print("cancel")
            case .cancel:
                print("bye")
            case .destructive:
                print("destructive")
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        cleanVariables()
    }
    
    
    private var tagFriendId: String? = nil
    
    func setTagFriendId(uid: String) {
        
        taggedFreindsUID.append(uid)
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendsData.Instance.Data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseTagFriendCell", for: indexPath) as! tagFriendsvwTableViewCell
        let data = FriendsData.Instance.Data[indexPath.row]
        
        cell.setData(data: data, controller: self)
        
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
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var searchTablevw: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Back(_ sender: UIBarButtonItem) {
      
        
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

