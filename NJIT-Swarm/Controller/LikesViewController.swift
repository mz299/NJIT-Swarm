//
//  LikesViewController.swift
//  foursquare-swarm
//
//  Created by Palash Bairagi on 11/2/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var likesTableView: UITableView!
    var checkInKey: String = ""
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likesCell", for: indexPath) as! LikesTableViewCell
        
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
        
        cell.profilePicture.image = UIImage(named:"samplePP.jpg")
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2
        cell.profilePicture.clipsToBounds = true
        
        cell.name.setTitle("Name", for: UIControlState.normal)
        
        return cell;
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "LikesTableViewCell", bundle: nil)
        likesTableView.register(nib, forCellReuseIdentifier: "likesCell")
        
        DBProvider.Instance.getLikes(withCheckinID: checkInKey, dataHandler: {(checkins) in
            print("Home View Controller", checkins)
            self.likesTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
