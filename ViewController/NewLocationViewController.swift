//
//  ViewController.swift
//  OnTheMap
//
//  Created by Shahad on 17/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class NewLocationViewController
: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var activityInicator: UIActivityIndicatorView!
    
    var studentArr : [StudentLocation]!
    var updatePin : Bool!
    var mediaURL: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func FindLocation(_ sender: Any) {
        
        guard let location = locationField.text else { return }
        if location == "" {
            showAlert(title: "wrong location name", message: "Enter location name to find place on map")
        }
        else {
            guard let urlText = linkField.text else { return }
            guard urlText != "" else {
                showAlert(title: "Empty Media Field", message: "You must provide a url.")
                return}
            mediaURL = urlText.prefix(7).lowercased().contains("http://") || urlText.prefix(8).lowercased().contains("https://") ? urlText : "https://" + urlText
            print(URL(string: mediaURL)!)
        }
        findLocation(location)
        
    }
    
    func setGeoCodingStatus(_ geocoding: Bool) {
        geocoding ? activityInicator.startAnimating() : activityInicator.stopAnimating()
    }
    
    
    
    
    func findLocation(_ location: String) {
        self.setGeoCodingStatus(true)
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in
            
            guard error == nil else {
                self.showAlert(title: "Failed", message: "Can not find spot: \(location)")
                return
            }
            let coordinate = placemark?.first!.location!.coordinate
            print(coordinate?.latitude ?? 0)
            print(coordinate?.longitude ?? 0)
            self.setGeoCodingStatus(false)
            self.performSegue(withIdentifier: "Finish", sender: (location, coordinate))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Finish" {
            let controller = segue.destination as! VerifiedLocationViewController
            let locationDetails = sender as!  (String, CLLocationCoordinate2D)
            controller.location = locationDetails.0
            controller.coordinate = locationDetails.1
            controller.updatePin = updatePin
            controller.studentLocArray = studentArr
            
            print("prepare URL: \(mediaURL)")
            controller.url = mediaURL
        }
    }
    


}

