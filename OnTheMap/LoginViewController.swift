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
        //TODO: Remove hack use of button
        UdClient.sharedInstance().deleteSessionID() { (success, errorString) in
            if success {
                print("Logout successful")
            } else {
                print("Logout failed")
            }
        }
//        UdClient.sharedInstance().loadUdacitySignUpPage()
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        self.view.endEditing(false)
        if let userName = emailTextField.text {
            if let password = passwordTextField.text {
                UdClient.sharedInstance().authenticateWithUsername(userName, password: password) {
                    (success, errorString) in
                    if success {
//                        self.completeLogin()
                    } else {
                        //TODO: Show user error
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
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(),{
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let resultVC = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(resultVC, animated: true, completion: nil)

        })
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
