//
//  SignUpViewController.swift
//  NJIT-Swarm
//
//  Created by Min Zeng on 02/11/2017.
//  Copyright © 2017 Team4. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let SIGNUP_TO_HOME_SEGUE = "signupToHome"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumTxt.keyboardType = UIKeyboardType.phonePad
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var phoneNumTxt: UITextField!
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if isValidated(){
            AuthProvider.Instance.signUp(email: emailTxt.text!, password: passwordTxt.text!, username: nameTxt.text!, phone: phoneNumTxt.text!, authHandler: { (message) in
                if message != nil {
                    self.showAlert(message: message!)
                } else {
                    self.login()
                }
            })
        }
    }
    
    //Validate the View Controller
    func isValidated() -> Bool{
        if(!isEmpty() && isPasswordMatched() && isPhoneNumberCorrect()){
            return true
        }
        return false
    }
    
    //Check if any textField is empty
    func isEmpty() -> Bool{
        
        if(nameTxt.text == ""){
            self.showAlert(message: "Please Enter Name")
            return true
        }
        
        if(emailTxt.text == ""){
            self.showAlert(message: "Please Enter Email")
            emailTxt.becomeFirstResponder()
            return true
        }
        
        if(passwordTxt.text == ""){
            self.showAlert(message: "Please Enter Password")
            passwordTxt.becomeFirstResponder()
            return true
        }
        
        if(confirmPasswordTextField.text == ""){
            self.showAlert(message: "Please Enter Confirm Password")
            confirmPasswordTextField.becomeFirstResponder()
            return true
        }
        
        if(phoneNumTxt.text == ""){
            self.showAlert(message: "Please Enter Phone")
            phoneNumTxt.becomeFirstResponder()
            return true
        }
        return false
    }
    
    //Checek whether the password matches the confirm password.
    func isPasswordMatched() -> Bool{
        if(passwordTxt.text != confirmPasswordTextField.text){
            self.showAlert(message: "Password doesn't match Confirm Password")
            return false
        }
        return true
    }
    
    // Check whether the phone number is 10 digit numeric.
    func isPhoneNumberCorrect() -> Bool {
        let PHONE_REGEX = "\\A[0-9]{10}\\z"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        if(!phoneTest.evaluate(with: phoneNumTxt.text))
        {
            self.showAlert(message: "Invalid Phone Number")
            return false
        }
        return true
    }
    
    func login() {
        if emailTxt.text != "" && passwordTxt.text != "" {
            AuthProvider.Instance.login(email: emailTxt.text!, password: passwordTxt.text!, authHandler: { (message) in
                if message != nil {
                    self.showAlert(message: message!)
                } else {
                    self.performSegue(withIdentifier: self.SIGNUP_TO_HOME_SEGUE, sender: nil)
                }
            })
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

