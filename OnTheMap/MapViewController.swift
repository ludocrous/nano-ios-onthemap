//
//  MaptViewController.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var activityView: UIActivityIndicatorView?
    var activityBlur: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        populateStudentLocations()
    }

    
    @IBAction func refreshButtonTouch(sender: AnyObject) {
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
                dispatch_async(dispatch_get_main_queue(),{
                    let myAlert = UIAlertController(title: "Unable to refresh data", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    myAlert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(myAlert,animated: true, completion: nil)
                })

            }
        }
    }
    
    func populateStudentLocations(){
        // When the array is complete, we add the annotations to the map.
        print("Annotations Loaded: \(StudentLocationCollection.sharedInstance().annotations.count)")
        self.mapView.addAnnotations(StudentLocationCollection.sharedInstance().annotations)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
//            pinView!.pinColor = .Red
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }

}

