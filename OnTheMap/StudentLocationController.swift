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
    // This enum denotes the two states under which this view can operate
    enum SLLayoutState {
        case GeoEntry
        case UrlEntry
    }
    // var to contain the current desired state
    var currentLayoutState: SLLayoutState = .GeoEntry

    //MARK Constants
    let oceanColour = UIColor(red: 0.0, green: 0.25, blue: 0.5, alpha: 1.0)
    let addressTextPrompt = "Enter Your Location"
    let linkTextPrompt = "Enter a link to share"
    
    var activityView: UIActivityIndicatorView?
    
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
    
    override func viewWillAppear(animated: Bool) {
        currentLayoutState = .GeoEntry
    }
    
    func configureForState(state: SLLayoutState) {
        switch state {
        case .GeoEntry:
            // Settings for the initial address entry state of the view
            geoLabelView.hidden = false
            geoEntryView.hidden = false
            urlEntryView.hidden = true
            mapContainerView.hidden = true
            addressTextField.text = addressTextPrompt
            addressTextField.placeholder = addressTextPrompt
            cancelButton.setTitleColor(oceanColour, forState: .Normal)
            
        case .UrlEntry:
            // Settings for the Url link entry once address has been forward geocoded and displayed.
            geoLabelView.hidden = true
            geoEntryView.hidden = true
            urlEntryView.hidden = false
            mapContainerView.hidden = false
            linkTextField.text = linkTextPrompt
            linkTextField.placeholder = linkTextPrompt
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            submitButtonView.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
            positionMapViewForUserAnnotation()
        }
    }
    
    func positionMapViewForUserAnnotation() {
        // Retrieve student location from singleton and build an annotation
        if let userAnnotation:MKAnnotation = UdUser.sharedInstance().studentLocation.asMapAnnotationPointOnly() {
            //Position map to show gecoded address
            mapView.showAnnotations([userAnnotation], animated: true)
        }
    }
    
    func forwardGeocodeAddress( addressString: String) {
        // Bring on a activity view to show we are busy
        activityView  = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView?.center = self.view.center
        activityView?.color = UIColor.whiteColor()
        activityView?.startAnimating()
        self.view.addSubview(activityView!)
        
        // Start the geocode
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString, completionHandler: {(placemarks, error) -> Void in
            // Regardless of result - force the dismisal of the activity view
            dispatch_async(dispatch_get_main_queue(),{
                self.activityView?.stopAnimating()
                self.activityView?.removeFromSuperview()
            })

            if((error) != nil){
                // Show alert to user
                displayAlertOnMainThread("Address could not be found", message: "Please enter another address", onViewController: self)
                UdUser.sharedInstance().resetLocation()
            } else
                // Create a single annotation by loading
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    dbg("Lat: \(coordinates.latitude) - Long: \(coordinates.longitude)")
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
        // Close the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnMapButtonTouch(sender: AnyObject) {
        // Start the geocoding process
        if let address = addressTextField.text where address != addressTextPrompt && address != "" {
            forwardGeocodeAddress(address)
        } else {
            displayAlert("You must enter a location", message: nil, onViewController: self)
        }
        
    }

    @IBAction func submitButtonTouch(sender: AnyObject) {
        // Commit the position and url to the database
        if let url = linkTextField.text where url != linkTextPrompt && url != "" {
            // Check url is reasonably formed
            if ((url as NSString).substringToIndex(7)).lowercaseString == "http://" || ((url as NSString).substringToIndex(8)).lowercaseString == "https://"{
                UdUser.sharedInstance().studentLocation.mediaURL = url
                // if so call POST
                ParseClient.sharedInstance().postStudentLocation() {(success, errorString) in
                    if success {
                        //Reload the data from Parse
                        ParseClient.sharedInstance().loadStudentLocations() { (success, errorString ) in
                            //Irrespective of success - return to tab view
                            dispatch_async(dispatch_get_main_queue(),{
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }
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

}
