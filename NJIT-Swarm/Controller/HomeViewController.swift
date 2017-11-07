//
//  HomeViewController.swift
//  foursquare-swarm
//
//  Created by Palash Bairagi on 10/21/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var timelineTableView: UITableView!
    private let PROFILE_PAGE_SEGUE = "profilePage"
    private let FRIEND_PAGE_SEGUE = "friendPage"
   
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserDetails()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            getCurrentLocation()
        }
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        timelineTableView.register(nib, forCellReuseIdentifier: "timelineCell")
        
        FriendsData.Instance.update{ (friends) in
            CheckinsData.Instance.update(handler: {(checkins) in
                print(checkins)
                self.timelineTableView.reloadData()
            })
        }
        
        print(FriendsData.Instance.Data.count)
   }
    
    func setUserDetails(){
        profilePicture.image = UIImage(named:"samplePP.jpg")
        profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 2
        profilePicture.clipsToBounds = true
    }
    
    func getCurrentLocation(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        mapView.setRegion(region, animated: true)
        
       /* Pin Annotation
         
         let myAnnotation: MKPointAnnotation = MKPointAnnotation()
         myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
         myAnnotation.title = "Current location"
        
         mapView.addAnnotation(myAnnotation)
        */
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendsData.Instance.Data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(FriendsData.Instance.Data[indexPath.row], indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimelineTableViewCell
        
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
        
        let checkIn = CheckinsData.Instance.Data[indexPath.row]
        
        cell.profilePicture.image = UIImage(named:"samplePP.jpg")
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2
        cell.profilePicture.clipsToBounds = true
        
        cell.name.setTitle(checkIn.uid, for: UIControlState.normal)
        cell.place.text = checkIn.place
        cell.detail.text = checkIn.message
      //  cell.rating.text = "\(checkIn.rating)"
        cell.commentCountButton.setTitle("Comments(\(checkIn.numofcomment))", for: UIControlState.normal)
        cell.dateTimeLabel.text = "\(checkIn.timestamp)"
       // cell.likeCountButton.setTitle("(\(checkIn.likes))", for: UIControlState.normal)
        cell.checkInKey = checkIn.checkinid
        cell.isLiked = checkIn.youliked
        
        if(checkIn.youliked){
            cell.likeButton.tintColor = UIColor.red
        }
        else{
            cell.likeButton.tintColor = UIColor.gray
        }
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func loadNewScreen(controller: UIViewController) {
        self.present(controller, animated: true) { () -> Void in
        };
    }
    
    @IBAction func profilePictureTapped(_ sender: Any) {
         performSegue(withIdentifier: PROFILE_PAGE_SEGUE, sender: nil)
    }
    
    @IBAction func profileButtonClicked(_ sender: Any) {
          performSegue(withIdentifier: PROFILE_PAGE_SEGUE, sender: nil)
    }
    
    @IBAction func addFriendButtonClicked(_ sender: Any) {
            performSegue(withIdentifier: FRIEND_PAGE_SEGUE, sender: nil)
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

}
