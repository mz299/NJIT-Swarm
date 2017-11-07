//
//  CheckinViewController.swift
//  NJIT-Swarm
//
//  Created by Apoorva Reed on 11/4/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit
import MapKit


class CheckinViewController: UIViewController{
    var currentlocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
    
    
    @IBOutlet var mapView: MKMapView!
    @IBAction func buttonCheckin(_ sender: UIBarButtonItem) {
        Checkin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -122.431297)
        
        
        
        zoomMapOn(locations: initialLocation)
        
        let sampleStarbucks = Venue(title: "Dummy Starbucks", locationName: "Imagination Street", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.431297))
        mapView.addAnnotation(sampleStarbucks)
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    
    
    func Checkin(){
        
        
        CLGeocoder().reverseGeocodeLocation(currentlocation, completionHandler: {(placemarks, error) -> Void in
            //            print(self.currentlocation)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error!.localizedDescription))
                return
            }
            
            if placemarks!.count > 0 {
                let place = placemarks
                
                let pm = place![0]
                
                let title = pm.name
                let locality = pm.locality
                print(pm.administrativeArea!)
                print(pm.country!)
                let lattitude = self.currentlocation.coordinate.latitude
                let longitude = self.currentlocation.coordinate.longitude
                
                // print(self.currentlocation.coordinate.latitude)
                var LocationName :Venue
                LocationName = Venue(title: title!, locationName: locality!, coordinate: CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
                
                self.mapView.addAnnotation(LocationName)
                
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

