//
//  CheckinViewController.swift
//  NJIT-Swarm
//
//  Created by Apoorva Reed on 11/4/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit
import MapKit
import Foundation
//import Cosmos

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class CheckinViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var selectedPin:MKPlacemark? = nil
    var lattitude: Double? = nil
    var longitude: Double? = nil
    var titleName: String? = nil
    var locality: String? = nil
    var taggedfriends: String = ""
    var taggedfrienddata :String = ""
    var Rating:Float = 3.0
    
    var currentlocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
    var resultSearchController:UISearchController? = nil
    
    @objc func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
   
    //@IBOutlet weak var RatingInput: CosmosView!
    
    
    @IBAction func ratingChanged(_ sender: Any) {
        print("Raitng Changed")
    }
    
    @IBAction func CheckInButton(_ sender: UIButton) {
        print(taggedfrienddata)
        Checkin(taggedfrienddataone: taggedfrienddata)
    }
    @IBOutlet var ReviewText: UITextView!
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var ratingValue: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // taggedfrienddata = taggedfriends
        
        print(taggedfrienddata)
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
        
        
        
        zoomMapOn(locations: initialLocation)
        
        let sampleStarbucks = Venue(title: "Dummy Starbucks", locationName: "Imagination Street", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.431297))
        mapView.addAnnotation(sampleStarbucks)
        mapView.delegate = self
        
    
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        // Do any additional setup after loading the view.
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
    }
    
    @IBAction func TagFriends(_ sender: UIButton) {
        performSegue(withIdentifier: "gotToTagFriends", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destvc = segue.destination as! TagFriendViewController
        destvc.lattitude = lattitude
        destvc.longitude = longitude
        destvc.Rating = Rating
        destvc.Review = ReviewText.text
        destvc.titleName = titleName
    }
    
    
    @IBAction func addPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            //profileImageView.image = selectedImage
            let newSize = CGSize(width: 160, height: 160)
            let sizedImage = selectedImage.resizeImageWith(newSize: newSize)
            let imageData = UIImageJPEGRepresentation(sizedImage, 0.0)
//            StorageProvider.Instance.uploadProfilePic(image: imageData, uid: AuthProvider.Instance.getUserID()!, handler: { (url) in
//                DBProvider.Instance.setUserData(key: Constants.PROFILE_IMAGE_URL, value: url!)
//            })
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    func Checkin(taggedfrienddataone: String){
        
        
        
        Rating = Float(ratingValue.text!)!
        
        CLGeocoder().reverseGeocodeLocation(currentlocation, completionHandler: {(placemarks, error) -> Void in
            //            print(self.currentlocation)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error!.localizedDescription))
                return
            }
            
            if placemarks!.count > 0 {
                let place = placemarks
                
                let pm = place![0]
                
//                let title = pm.name
//                let locality = pm.locality
                print(pm.administrativeArea!)
                print(pm.country!)
                
//                let alert = UIAlertController(title: "Alert", message: "Do you want to checkin?", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//
//                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//                    switch action.style{
//
//                    case .default:
//                        print("default")
//                    case .cancel:
//                        print("cancel")
//                    case .destructive:
//                        print("destructive")
//                    }
//                }))
                
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
                        DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: Review!, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: nil, rating: self.Rating)
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
                
                
                
               
                // to get data
//                UserCheckinsData.Instance.getUserCheckinsData(withID: AuthProvider.Instance.getUserID()!, handler: { (datas) in
//                    let count = datas.count
//                    for data in datas {
//                        let place = data.place
//                        let message = data.message
//                        let numoflikes = data.numoflike
//                    }
//                })
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServiceAuthenticationStatus()
    }
    
    var locationManager = CLLocationManager()
    
    
    let regionRadius : CLLocationDistance = 1000
    func zoomMapOn(locations: CLLocation){
        let coordinateRegion  = MKCoordinateRegionMakeWithDistance(locations.coordinate, regionRadius * 2, regionRadius * 2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func checkLocationServiceAuthenticationStatus(){
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            
        }else{
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
}

extension CheckinViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        self.mapView.showsUserLocation = true
        zoomMapOn(locations: location)
        currentlocation = location
        
    }
}

//extension CheckinViewController: MKMapViewDelegate{
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//        if let annotation = annotation as? Venue{
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as?MKPinAnnotationView{
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            }
//            else{
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//
//            }
//            return view
//
//        }
//        return nil
//    }
//
//}


extension CheckinViewController : MKMapViewDelegate {
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
        button.addTarget(self, action: #selector(CheckinViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

extension CheckinViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        lattitude = placemark.coordinate.latitude
        longitude = placemark.coordinate.longitude
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        titleName = placemark.name!
        locality = placemark.locality!
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
