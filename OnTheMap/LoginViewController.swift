//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpButtonTouch(sender: UIButton) {
        self.view.endEditing(true)
        UdClient.sharedInstance().loadUdacitySignUpPage()
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        self.view.endEditing(false)
        if let userName = emailTextField.text where userName != "" {
            if let password = passwordTextField.text where password != "" {
                UdClient.sharedInstance().authenticateWithUsername(userName, password: password) {
                    (success, errorString) in
                    if success {
                        self.completeLogin()
                    } else {
                        displayAlertOnMainThread("Login Failed", message: errorString, onViewController: self)
                        err("Error logging in: \(errorString)")
                    }
                }
                
            } else {
                displayAlert("Enter a password", message: nil, onViewController: self)
            }
        } else {
            displayAlert("Enter a user name", message: nil, onViewController: self)
        }
    }
    
    func moveToMainNavController() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("MainNavController") as! UINavigationController
        self.presentViewController(resultVC, animated: true, completion: nil)
    }
    
    func completeLogin() {
        ParseClient.sharedInstance().loadStudentLocations() { (success, errorstring) in
            if success {
                dbg ("Student locations loaded - Count: \(StudentLocationCollection.sharedInstance().collection.count)")
                dispatch_async(dispatch_get_main_queue(),{
                    self.moveToMainNavController()
                })
            } else {
                err ("Failed to load student locations")
            }
        }
    }
    
    //MARK: Keyboard handling code
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
