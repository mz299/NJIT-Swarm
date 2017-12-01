//
//  SettingViewController.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 21/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var switchTag: UISwitch!
    @IBOutlet weak var switchTrack: UISwitch!
    @IBOutlet weak var switchPhone: UISwitch!
    @IBOutlet weak var switchEmail: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userdata = FriendsData.Instance.getData(uid: AuthProvider.Instance.getUserID()!) {
            switchTag.isOn = userdata.allow_tag
            switchTrack.isOn = userdata.allow_track
            switchPhone.isOn = userdata.show_phone
            switchEmail.isOn = userdata.show_email
        }
        
//        startActivityIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender == switchTag {
            DBProvider.Instance.setUserData(key: Constants.ALLOW_TAG, value: sender.isOn)
        }
        else if sender == switchTrack {
            DBProvider.Instance.setUserData(key: Constants.ALLOW_TRACK, value: sender.isOn)
        }
        else if sender == switchPhone {
            DBProvider.Instance.setUserData(key: Constants.SHOW_PHONE, value: sender.isOn)
        }
        else if sender == switchEmail {
            DBProvider.Instance.setUserData(key: Constants.SHOW_EMAIL, value: sender.isOn)
        }
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
