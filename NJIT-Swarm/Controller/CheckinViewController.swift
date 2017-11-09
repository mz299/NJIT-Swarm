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


class CheckinViewController: UIViewController{
    var selectedPin:MKPlacemark? = nil
    var lattitude: Double? = nil
    var longitude: Double? = nil
    var titleName: String? = nil
    var locality: String? = nil
    var taggedfriends: String = ""
    var taggedfrienddata :String = ""
    
    var currentlocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
    var resultSearchController:UISearchController? = nil
    
    
   
    //@IBOutlet weak var RatingInput: CosmosView!
    
    
    
    @IBAction func CheckInButton(_ sender: UIButton) {
        print(taggedfrienddata)
        Checkin(taggedfrienddataone: taggedfrienddata)
    }
    @IBOutlet var ReviewText: UITextView!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taggedfrienddata = taggedfriends
        
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
    
    
    
    func Checkin(taggedfrienddataone: String){
        
        
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
                
                let alert = UIAlertController(title: "UIAlertController", message: "Would you like to Checkin?", preferredStyle: UIAlertControllerStyle.alert)
                
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
                        if taggedfrienddataone != ""{
                            let taguids = self.taggedfrienddata.split(separator: "_")
//                             DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: Review!, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: taguids)
                        }else{
                            DBProvider.Instance.saveCheckin(withID: AuthProvider.Instance.getUserID()!, place: self.titleName!, message: Review!, latitude: self.lattitude!, longitude: self.longitude!, taggedUids: nil, rating: 5)
                        }
                        
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

extension CheckinViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let annotation = annotation as? Venue{
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as?MKPinAnnotationView{
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                
            }
            return view
            
        }
        return nil
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
