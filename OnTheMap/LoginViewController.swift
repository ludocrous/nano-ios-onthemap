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
        if let userName = emailTextField.text {
            if let password = passwordTextField.text {
                UdClient.sharedInstance().authenticateWithUsername(userName, password: password) {
                    (success, errorString) in
                    if success {
                        self.completeLogin()
                    } else {
                        //TODO: Show user error
                        self.showErrorAlert("Cannot login in")
                        print("Error logging in: \(errorString)")
                    }
                }
                
            } else {
                //TODO: Show user error
                //Error no password
            }
        } else {
            //TODO: Show user error
            // Error - no user name entered
        }
    }
    
    func showErrorAlert(errorMessage: String) {
        dispatch_async(dispatch_get_main_queue(),{
            let myAlert = UIAlertController(title: errorMessage, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            myAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(myAlert,animated: true, completion: nil)
        })
        
    }
    
    func completeLogin() {
        ParseClient.sharedInstance().loadStudentLocations() { (success, errorstring) in
            if success {
                print ("Student locations loaded - Count: \(StudentLocationCollection.sharedInstance().collection.count)")
                dispatch_async(dispatch_get_main_queue(),{
                    let storyboard = UIStoryboard (name: "Main", bundle: nil)
                    let resultVC = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
                    self.presentViewController(resultVC, animated: true, completion: nil)
                })
            } else {
                print ("Failed to load student locations")
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
