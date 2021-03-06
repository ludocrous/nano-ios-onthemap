//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Derek Crous on 02/10/2015.
//  Copyright © 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        refreshView()
    }
    
    func refreshView() {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationCollection.sharedInstance().collection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as? LocationViewCell
        
        let studentLoc = StudentLocationCollection.sharedInstance().collection[indexPath.row]
            cell?.studentNameLabel.text = studentLoc.fullName
//        cell?.textLabel?.text = StudentLocationCollection.sharedInstance().collection[indexPath.row].fullName
        if let url = studentLoc.mediaURL {
            cell?.mediaURL.text = url
        } else {
            cell?.mediaURL.text = ""
        }
        
        cell?.daysUpdated.textColor = UIColor.blackColor()
        if let daysSinceUpdate = studentLoc.daysSinceLastUpdated() {
            switch daysSinceUpdate {
            case 0:
                cell?.daysUpdated.text = "Updated today"
                cell?.daysUpdated.textColor = UIColor.redColor()
            case 1:
                cell?.daysUpdated.text = "Updated yesterday"
            default:
                cell?.daysUpdated.text = "Updated \(daysSinceUpdate) days ago"
            }

        } else {
            cell?.daysUpdated.text = ""
        }

        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let mediaurl = StudentLocationCollection.sharedInstance().collection[indexPath.row].mediaURL {
            if let url = NSURL(string: mediaurl) {
                UIApplication.sharedApplication().openURL(url)
                return
            }
        }
        displayAlert("Unable to open URL", message: nil, onViewController: self)
    }

}

