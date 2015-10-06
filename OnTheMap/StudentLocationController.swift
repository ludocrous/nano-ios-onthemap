//
//  StudentLocationController.swift
//  OnTheMap
//
//  Created by Derek Crous on 05/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationController: UIViewController, UITextFieldDelegate {
    
    enum SLLayoutState {
        case GeoEntry
        case UrlEntry
    }
    
    let oceanColour = UIColor(red: 0.0, green: 0.25, blue: 0.5, alpha: 1.0)
    var currentLayoutState: SLLayoutState = .GeoEntry

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var geoLabelView: UIView!
    @IBOutlet weak var urlEntryView: UIView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var geoEntryView: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureForState(currentLayoutState)
    }
    
    func configureForState(state: SLLayoutState) {
        switch state {
        case .GeoEntry:
            print("Engaging Geo Entry")
            geoLabelView.hidden = false
            geoEntryView.hidden = false
            urlEntryView.hidden = true
            mapContainerView.hidden = true
            cancelButton.setTitleColor(oceanColour, forState: .Normal)
            
        case .UrlEntry:
            print("Engaging Url Entry")
            geoLabelView.hidden = true
            geoEntryView.hidden = true
            urlEntryView.hidden = false
            mapContainerView.hidden = false
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            submitButtonView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
            positionMapViewForUserAnnotation()
        }
    }
    
    /*
    let effect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    activityBlur = UIVisualEffectView(effect: effect)
    activityBlur!.frame = self.view.bounds;
    self.view.addSubview(activityBlur!)
    
    activityView  = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    activityView?.center = self.view.center
    activityView?.color = UIColor.blackColor()
    activityView?.startAnimating()
    self.view.addSubview(activityView!)
    
    ParseClient.sharedInstance().loadStudentLocations() { (success, errorString ) in
    dispatch_async(dispatch_get_main_queue(),{
    self.activityView?.stopAnimating()
    self.activityView?.removeFromSuperview()
    self.activityBlur?.removeFromSuperview()
    })
    if success {
    print("Successful refresh of data")
    } else {
    print("Failed to refresh data")
    displayAlertOnMainThread("Unable to refresh data", message: nil, onViewController: self)
    }
    }

*/
    
    func positionMapViewForUserAnnotation() {
        if let userAnnotation:MKAnnotation = UdUser.sharedInstance().studentLocation.asMapAnnotationPointOnly() {
            mapView.showAnnotations([userAnnotation], animated: true)
        }
    }
    
    func forwardGeocodeAddress( addressString: String) {
        //TODO: Show the user you are busy
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                displayAlertOnMainThread("Address could not be found", message: "Please re enter address", onViewController: self)
                UdUser.sharedInstance().resetLocation()
            } else
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Lat: \(coordinates.latitude) - Long: \(coordinates.longitude)")
                    dispatch_async(dispatch_get_main_queue(),{
                        UdUser.sharedInstance().studentLocation.latitude = coordinates.latitude
                        UdUser.sharedInstance().studentLocation.longitude = coordinates.longitude
                        UdUser.sharedInstance().studentLocation.mapString = addressString
                        self.currentLayoutState = .UrlEntry
                        self.configureForState(self.currentLayoutState)
                    })
                    
            }
        })
        
    }
    
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnMapButtonTouch(sender: AnyObject) {
        if let address = addressTextField.text {
            forwardGeocodeAddress(address)
        } else {
            displayAlert("You must enter a location", message: nil, onViewController: self)
        }
        
    }

    @IBAction func submitButtonTouch(sender: AnyObject) {
        if let url = linkTextField.text {
            if ((url as NSString).substringToIndex(7)).lowercaseString == "http://" || ((url as NSString).substringToIndex(8)).lowercaseString == "https://"{
                UdUser.sharedInstance().studentLocation.mediaURL = url
                ParseClient.sharedInstance().postStudentLocation() {(success, errorString) in
                    if success {
                        //TODO: Pop back to tab view and refresh
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        displayAlertOnMainThread("Unable to commit location", message: nil, onViewController: self)
                    }
                }
            }
            else {
                displayAlert("Invalid URL link", message: "Link must start \"http://\" or \"https://\"", onViewController: self)
            }
        } else {
            displayAlert("You must enter a URL link", message: nil, onViewController: self)
        }
    }
    //Mark: Keyboard Handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
