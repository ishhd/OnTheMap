//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shahad on 20/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController {
    
    @IBOutlet weak var Map: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Map.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(animated)
    }
    
    @IBAction func refresh(_ sender: Any) {
        UdacityAPI.getStudentLocation(singleStudent: false, completion:{ (data, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            DispatchQueue.main.async {
                SLocationData.studentsData = data
                self.copyDataStudent()
            }
            
        })
    }
    
    @IBAction func addLocation(_ sender: Any) {
        let alertVC = UIAlertController(title: "Warning!", message: "You've already put your pin on the map.\nWould you like to overwrite it?", preferredStyle: .alert)
        
        UdacityAPI.getStudentLocation(singleStudent: false, completion:{ (data, error) in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            if data.count > 0 {
                alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (_) in
                    self.performSegue(withIdentifier: "addSpot",  sender: (true, data))
                }))
                
                alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "addSpot", sender: (false, []))
            }})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSpot" {
            let destinationVC = segue.destination as? NewLocationViewController
            let updateStudentInfo = sender as? (Bool, [StudentLocation])
            destinationVC?.updatePin = updateStudentInfo?.0
            destinationVC?.studentArr = updateStudentInfo?.1
        }
    }
    
    func copyDataStudent() {
        self.annotations.removeAll()
        self.Map.removeAnnotations(self.Map.annotations)
        
        for val in SLocationData.studentsData {
            self.annotations.append(val.getMapAnnotation())
        }
        self.Map.addAnnotations(self.annotations)
    }
    
    func alert(_ title: String, _ messageBody: String) {
        let alert = UIAlertController(title: title, message: messageBody, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in}
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let annotation = view.annotation else {
                return
            }
            guard var subtitle = annotation.subtitle else {
                return
            }
            if subtitle!.isValidURL {
                if subtitle!.starts(with: "www") {
                    subtitle! = "https://" + subtitle!
                }
                let url = URL(string: subtitle!)
                UIApplication.shared.open(url!)
            } else {
                
                alert("No URL", "There's no URL to open")
            }
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        _ = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
    
}
