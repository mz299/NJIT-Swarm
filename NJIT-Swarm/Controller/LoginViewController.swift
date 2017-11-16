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

    let path = NSHomeDirectory()+"/documents/user-info.plist";
    var dictionary: NSMutableDictionary!
    let fileManager = FileManager.default
    var username = ""
    var password = ""
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        checkFile()
        dictionary = NSMutableDictionary(contentsOfFile: path)
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
        if !fileManager.fileExists(atPath: path) {
            let srcPath = Bundle.main.path(forResource: "user-info", ofType: "plist")
            do {
                //Copy the project plist file to the documents directory.
                try fileManager.copyItem(atPath: srcPath!, toPath: path)
            } catch {
                print("File copy error!")
            }
        }
    }

}
