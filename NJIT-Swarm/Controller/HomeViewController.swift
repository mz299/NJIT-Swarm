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

protocol HandleHomeMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class HomeViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
   
    // testing
    var selectedPin:MKPlacemark? = nil
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var timelineTableView: UITableView!
    private let PROFILE_PAGE_SEGUE = "profilePage"
    private let FRIEND_PAGE_SEGUE = "friendPage"
    
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            getCurrentLocation()
            
        }
        
        //testing
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable

        //testing
        locationSearchTable.handleHomeMapSearchDelegate = self
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        timelineTableView.register(nib, forCellReuseIdentifier: "timelineCell")
        
        
            
   }
    
    
    @IBAction func buttonFriendlocation(_ sender: Any) {
//        mapView.removeAnnotations(mapView.annotations)
        updateFriendLocation()
        
    }
    @IBAction func buttonGotoCurrentLocation(_ sender: Any) {
        getCurrentLocation()
    }
    
    @IBAction func buttonSOS(_ sender: UIButton) {
        let frienddatas = FriendsData.Instance.Data
        var nearbyUserIds = Array<String>()
        
        for data in frienddatas
        {
            nearbyUserIds.append(data.uid)
        }
        let myname = FriendsData.Instance.getCurrentUserData()!.username
        DBProvider.Instance.saveNotification(withIds: nearbyUserIds, msg: "\(myname) says - feeling unsafe. Please check my location.")
    }
    func updateFriendLocation()
    {
//        let annotations : MKAnnotation
//        if annotations == mapView.annotations as! MKAnnotation {
//            for _annotation in annotations {
//                if let annotation = _annotation as? MKAnnotation
//                {
//                    self.mapView.removeAnnotation(annotation)
//                }
//            }
//        }
        
        
        mapView.removeAnnotations(mapView.annotations)
        var friendlocation : CLLocationCoordinate2D
        var pin : pinAnnotation
        let frienddatas = FriendsData.Instance.Data
        for data in frienddatas {
            
            if !data.allow_track {
                continue
            }
            //handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
            friendlocation  = CLLocationCoordinate2DMake(data.latitude, data.longitude)
            pin = pinAnnotation(title: data.username, subtitle: data.username, coordinate: friendlocation)
            mapView.addAnnotation(pin)
        }
        
    }
    
    func loadUserData() {
        
        let userData = FriendsData.Instance.getData(uid:AuthProvider.Instance.getUserID()!)
        
        let url = URL(string: (userData?.profile_image_url)!)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        self.profilePicture.image = image
                    }
                }
            }
        }).resume()
        
        self.profilePicture.layer.cornerRadius =  self.profilePicture.frame.size.height / 2
        self.profilePicture.clipsToBounds = true
        
    }
    
    func getCurrentLocation(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            //locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        mapView.setRegion(region, animated: true)
        DBProvider.Instance.saveUserLocation(withId: AuthProvider.Instance.getUserID()!, latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
        
        
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CheckinsData.Instance.Data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! TimelineTableViewCell
        
        let checkIn = CheckinsData.Instance.Data[indexPath.row]

        let taggedFriends = checkIn.taggedUserIds
        if(taggedFriends.count != 0)
        {
            var labelText = "With"
            for friendUID in taggedFriends {
                let friendData = FriendsData.Instance.getData(uid: friendUID)
                let uName = friendData?.username
                labelText += " \(uName!)"
            }
            cell.taggedFriendLabel.text = labelText
        }
        else
        {
            cell.taggedFriendLabel.text = ""
        }
        
        if checkIn.profile_image_url != "" {
            let url = URL(string: checkIn.profile_image_url)
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
        
        cell.userKey = checkIn.uid
        cell.name.setTitle(checkIn.username, for: UIControlState.normal)
        cell.place.text = checkIn.place
        cell.detail.text = checkIn.message
        cell.rating.text = "\(checkIn.rating)"
        cell.commentCountButton.setTitle("\(checkIn.numofcomment)", for: UIControlState.normal)
        cell.dateTimeLabel.text = Global.convertTimestampToDateTime(timeInterval: checkIn.timestamp)
        cell.likeCountButton.setTitle("\(checkIn.numoflike)", for: UIControlState.normal)
        cell.checkInKey = checkIn.checkinid
        cell.isLiked = checkIn.youliked
        
        if(checkIn.checkin_image_url == "")
        {
            cell.checkInPhoto.setImage(nil, for: .normal)
            cell.checkInPhoto.setTitle("", for: .normal)
        }
        else
        {
            cell.checkInPhoto.setImage(UIImage(named: "photo.png"), for: .normal)
        }
       
        if(checkIn.youliked){
            cell.likeButton.tintColor = UIColor.red
        }
        else{
            cell.likeButton.tintColor = UIColor.gray
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
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.timelineTableView.cellForRow(at: indexPath) as! TimelineTableViewCell
        
        if(cell.checkInKey != ""){
            let checkInDetail: CheckInDetailViewController = CheckInDetailViewController()
            checkInDetail.checkInKey = cell.checkInKey
            var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!;
            while ((topController.presentedViewController) != nil) {
                topController = topController.presentedViewController!;
            }
            topController.present(checkInDetail, animated: false, completion: nil)
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        if AuthProvider.Instance.getUserID() != nil {
        FriendsData.Instance.update{ (friends) in
            CheckinsData.Instance.update(handler: {(checkins) in
                self.loadUserData()
                self.timelineTableView.reloadData()
                self.updateFriendLocation()
            })
        }
      }
    }
    @objc func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}
extension HomeViewController: HandleHomeMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension HomeViewController : MKMapViewDelegate {
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0,y :0), size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(HomeViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
