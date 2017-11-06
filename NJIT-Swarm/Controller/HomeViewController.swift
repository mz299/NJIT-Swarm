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

class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var timelineTableView: UITableView!
    private let PROFILE_PAGE_SEGUE = "profilePage"
    private let FRIEND_PAGE_SEGUE = "friendPage"
    private let CHECK_IN_PAGE_SEGUE = "check-in"
    
    var checkIns: [CheckIn] = []
    
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataToTimeline()
        setUserDetails()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            getCurrentLocation()
        }
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        timelineTableView.register(nib, forCellReuseIdentifier: "timelineCell")
   }

    func setDataToTimeline(){
        let c1 = CheckIn(key:"sdfSfDDFCDsdds", profilePictureName: "String", name: "Palash", dateAndTime: "1:23 AM", place: "NJIT", detail: "This is my university", rating: 3.4, likes: 12, comments: 2, isLiked: true)
        let c2 =  CheckIn(key:"sddsfjbncgCDsdds", profilePictureName: "String", name: "Min", dateAndTime: "12:26 PM", place: "Oak Hall", detail: "I stay here", rating: 4.5, likes: 52, comments: 1, isLiked: false)
        let c3 =  CheckIn(key:"skjdfJKNMSKVDsfd", profilePictureName: "String", name: "Surya", dateAndTime: "4:45 AM", place: "Harrison", detail: "Its too cold here", rating: 3.5, likes: 26, comments: 3, isLiked: true)
        let c4 =  CheckIn(key:"ASJlkjDDLSKPEOejdkl", profilePictureName: "String", name: "Asha", dateAndTime: "10:13 AM", place: "Jersey City", detail: "My Home", rating: 1.2, likes: 18, comments: 8, isLiked: true)
        let c5 =  CheckIn(key:"sdfSKcdsSCDCsdf", profilePictureName: "String", name: "Apoorva", dateAndTime: "6:56 PM", place: "University Center", detail: "Enjoying with friends", rating: 5.0, likes: 123, comments: 9, isLiked: false)
        let c6 =  CheckIn(key:"SssdcdSDDClksjdc", profilePictureName: "String", name: "Whatever", dateAndTime: "2:28 PM", place: "New York City", detail: "Nice Place", rating: 3.8, likes: 32, comments: 4, isLiked: true)
        checkIns.append(c1)
        checkIns.append(c2);checkIns.append(c3);checkIns.append(c4);checkIns.append(c5);checkIns.append(c6)
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
        return checkIns.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let checkIn = checkIns[indexPath.row]
        
        cell.profilePicture.image = UIImage(named:"samplePP.jpg")
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2
        cell.profilePicture.clipsToBounds = true
        
        cell.name.setTitle(checkIn.name, for: UIControlState.normal)
        cell.place.text = checkIn.place
        cell.detail.text = checkIn.detail
        cell.rating.text = "\(checkIn.rating)"
        cell.commentCountButton.setTitle("Comments(\(checkIn.comments))", for: UIControlState.normal)
        cell.dateTimeLabel.text = checkIn.dateAndTime
        cell.likeCountButton.setTitle("(\(checkIn.likes))", for: UIControlState.normal)
        cell.checkInKey = checkIn.checkInkey
        cell.isLiked = checkIn.isLiked
        
        if(checkIn.isLiked){
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
    
    @IBAction func mapTapped(_ sender: Any) {
        performSegue(withIdentifier: CHECK_IN_PAGE_SEGUE, sender: nil)
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
