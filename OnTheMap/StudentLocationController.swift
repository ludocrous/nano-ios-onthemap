//
//  StudentLocationController.swift
//  OnTheMap
//
//  Created by Derek Crous on 05/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class StudentLocationController: UIViewController {
    
    enum SLLayoutState {
        case GeoEntry
        case UrlEntry
    }
    
    let oceanColour = UIColor(red: 0.0, green: 0.25, blue: 0.5, alpha: 1.0)
    var currentLayoutState: SLLayoutState = .UrlEntry

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var geoLabelView: UIView!
    @IBOutlet weak var urlEntryView: UIView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findOnMapButton: BorderedButton!
    
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
            urlEntryView.hidden = true
            cancelButton.setTitleColor(oceanColour, forState: .Normal)
            
            
            
        case .UrlEntry:
            print("Engaging Url Entry")
            geoLabelView.hidden = true
            urlEntryView.hidden = false
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

        }
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
