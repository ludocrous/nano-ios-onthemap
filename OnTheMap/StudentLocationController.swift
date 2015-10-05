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

        }
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func findOnMapButtonTouch(sender: AnyObject) {
        let address = "Oxford Street, London, England"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            } else
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) - Long: \(coordinates.longitude)")
            }
        })    }

    @IBAction func submitButtonTouch(sender: AnyObject) {
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
