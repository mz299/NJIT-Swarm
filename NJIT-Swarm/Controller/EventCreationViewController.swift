//
//  EventCreationViewController.swift
//  NJIT-Swarm
//
//  Created by Asha Vatalia on 12/1/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class EventCreationViewController: UIViewController {

    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventDescription: UITextView!
    
    @IBOutlet weak var eventStartDate: UIDatePicker!
    
    @IBOutlet weak var eventEndDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventStartDate.minimumDate = Date()
        eventEndDate.minimumDate = Date()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        eventEndDate.minimumDate = eventStartDate.date
    }
    
    @IBAction func createEventBtn(_ sender: Any) {
        
    
        let name = eventName.text
        let location = eventLocation.text
        let description = eventDescription.text
        let startdate = eventStartDate.date.timeIntervalSince1970
        let enddate = eventEndDate.date.timeIntervalSince1970
        
        if name != "" && location != ""{
            
            DBProvider.Instance.saveEvent(withId: AuthProvider.Instance.getUserID()!, name: name!, location: location!, description: description!, startDate: startdate, endDate: enddate)
            
            let friendIds = FriendsData.Instance.getFriendIds()
            let username = FriendsData.Instance.getCurrentUserData()!.username
            let message = "\(username) created an event: \(name!)."
            DBProvider.Instance.saveNotification(withIds: friendIds, msg: message)
            
        
            let alert = UIAlertController(title: "Success", message: "Event created", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            
            let alert = UIAlertController(title: "Alert", message: "Event name and location should not be blank!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            
        }
    }
    

    
    
}
