//
//  LoginViewController.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 01/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let HOME_PAGE_SEGUE = "homePage"
    private let SIGN_UP_SEGUE = "signUpPage"

    let fileManager = FileManager.default
    var documentDirectory = ""
    var path = ""
//    let path = NSHomeDirectory()+"/documents/user-info.plist";
    var dictionary: NSMutableDictionary!
    var username = ""
    var password = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        checkFile()
        login()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    func login(){
        AuthProvider.Instance.login(email: dictionary!.object(forKey: "username")! as! String, password: dictionary!.object(forKey: "password")! as! String, authHandler: { (message) in
            if message != nil {
//                self.showAlert(message: message!)
            } else {
                self.dictionary.setValue(self.emailTextField.text, forKey: "username")
                self.dictionary.setValue(self.passwordTextField.text, forKey: "password")
                self.dictionary.write(toFile: self.path, atomically: true)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: self.HOME_PAGE_SEGUE, sender: nil)
            }
        })
    }
    
    @IBAction func login(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.login(email: emailTextField.text!, password: passwordTextField.text!, authHandler: { (message) in
                if message != nil {
                    self.showAlert(message: message!)
                } else {
                    self.dictionary.setValue(self.emailTextField.text, forKey: "username")
                    self.dictionary.setValue(self.passwordTextField.text, forKey: "password")
                    self.dictionary.write(toFile: self.path, atomically: true)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: self.HOME_PAGE_SEGUE, sender: nil)
                }
            })
        } else {
            showAlert(message: AUTH_ERROR_MESSAGE.EMAIL_PASSWORD_EMPTY)
        }
    } // login
    
    @IBAction func signUp(_ sender: Any) {
        performSegue(withIdentifier: SIGN_UP_SEGUE, sender: nil)
    } // signUp
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func checkFile() {
        print("In file Check")
        self.documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        self.path = documentDirectory.appending("/user-info.plist")
        
        if (!fileManager.fileExists(atPath: self.path)) {
            let dicContent:[String: String] = ["username": "", "password":""]
            self.dictionary = NSMutableDictionary(dictionary: dicContent)
            let success:Bool = self.dictionary.write(toFile: self.path, atomically: true)
            if success {
                print("file has been created!")
            }else{
                print("unable to create the file")
            }
            
        }else{
            print("file already exist")
            self.dictionary = NSMutableDictionary(contentsOfFile: self.path)
            print(self.path)
            print(self.dictionary)
        }
        
    }

}
