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
    
    var activityView: UIActivityIndicatorView?
//    var activityBlur: UIVisualEffectView?

   
    
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


                activityView  = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
                activityView?.center = self.view.center
                activityView?.color = UIColor.whiteColor()
                activityView?.startAnimating()
                self.view.addSubview(activityView!)

                UdClient.sharedInstance().authenticateWithUsername(userName, password: password) {
                    (success, errorString) in
                    dispatch_async(dispatch_get_main_queue(),{
                        self.activityView?.stopAnimating()
                        self.activityView?.removeFromSuperview()
                    })
                    
                    if success {
                        self.completeLogin()
                    } else {
                        self.shakeLoginFields()
                        displayAlertOnMainThread("Login Failed", message: errorString, onViewController: self)
                        err("Error logging in: \(errorString)")
                    }
                }
                
            } else {
                displayAlert("Enter a password", message: nil, onViewController: self)
            }
        } else {
            displayAlert("Enter a username/email", message: nil, onViewController: self)
        }
    }
    
    func createAnimationForTextField(textField: UITextField) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(textField.center.x - 10, textField.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(textField.center.x + 10, textField.center.y))
        return animation
    }
    
    func shakeLoginFields() {
        dispatch_async(dispatch_get_main_queue(),{
            var animation = self.createAnimationForTextField(self.emailTextField)
            self.emailTextField.layer.addAnimation(animation, forKey: "position")
            animation = self.createAnimationForTextField(self.passwordTextField)
            self.passwordTextField.layer.addAnimation(animation, forKey: "position")
        })
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
                displayAlertOnMainThread("Login Failed", message: "Unable to load student data", onViewController: self)
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
