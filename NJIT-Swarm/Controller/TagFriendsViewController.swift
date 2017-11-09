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
     var currentlocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
    
    
    
    @IBAction func CheckinTagFreinds(_ sender: UIButton) {
        
//        tagFriendId = "\(String(describing: tagFriendId))_"
        //let tagfrnddata = tagFriendId?.split(separator: "_")
        
        print(self.titleName)
        print(Review)
        print(self.lattitude)
        print(self.Rating)
        
        
        
        
        let alert = UIAlertController(title: "Confirm Checkin", message: "Would you like to Checkin?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
            switch action.style{
                
            case .default:
                print("continue")
                
                
                //lattitude = self.currentlocation.coordinate.latitude
                //longitude = self.currentlocation.coordinate.longitude
                let Review = self.ReviewText.text
                // print(self.currentlocation.coordinate.latitude)
                var LocationName :Venue
                LocationName = Venue(title: self.titleName!, locationName: self.locality!, coordinate: CLLocationCoordinate2D(latitude: self.lattitude!, longitude: self.longitude!))
                
                //                self.mapView.addAnnotation(LocationName)
                print(taggedfrienddataone)
                //                        if taggedfrienddataone != ""{
                //                            let taguids = self.taggedfrienddata.split(separator: "_")
                //                             DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: Review!, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: taguids)
                //                        }else{
                //
//                DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: Review!, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: nil, rating: self.Rating)
                DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: Review, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: taggedFreindsUID, rating: self.Rating)
                //                        }
                
                // to put data
                
                
                self.ReviewText.text = ""
                
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
        
    }
    
    
    private var tagFriendId: String? = nil
    
    func setTagFriendId(uid: String) {
        

        taggedFreindsUID.append(uid)
        
//        if tagFriendId != nil{
//            tagFriendId = "\(String(describing: tagFriendId))_\(uid)"
//        }else{
//              tagFriendId = uid
//        }
  
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
    
//    @IBAction func BackPressed(_ sender: UIButton) {
//        print("test")
//         performSegue(withIdentifier: "getTaggednames", sender: self)
//    }
    @IBAction func Back(_ sender: UIBarButtonItem) {
      
        
//        performSegue(withIdentifier: "getTaggednames", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destVC = segue.destination as! CheckinViewController
//        print("below is the tagfriend id")
//        print(tagFriendId!)
//        destVC.taggedfriends = tagFriendId!
//    }
    
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

