//
//  VerifiedLocationViewController.swift
//  
//
//  Created by Shahad on 23/03/1441 AH.
//

import Foundation
import UIKit
import MapKit

class VerifiedLocationViewController : UIViewController{
    
    var location: String!
    var coordinate: CLLocationCoordinate2D!
    var updatePin: Bool!
    var url: String!
    var studentLocArray : [StudentLocation]?
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard coordinate != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        addLocation(coordinate: coordinate)
    }
    
    @IBAction func finishButton(_ sender: Any) {
        UdacityAPI.getPublicUser { (userData, error) in
            guard let userData = userData else {
                return
            }
            
            let firstName: String = ""
            let lastName: String = ""
            
            let studentLocationRequest = PostLocation(uniqueKey: userData.key, firstName: firstName, lastName: lastName, mapString: self.location, mediaURL: self.url, latitude: Float(self.coordinate.latitude), longitude: Float(self.coordinate.longitude))
            
            
            if (self.updatePin!) {
                self.updateExistedSpot(postLocationData: studentLocationRequest) ?? self.postSpot(postLocationData: studentLocationRequest)
            
            }
            
            
        }
        }
    
    
    
    
    func postSpot(postLocationData: PostLocation) {
        UdacityAPI.postStudentLocation(postLocation: postLocationData) { (success,error) in
            if error != nil{
                self.showAlert(title: "Can't post new pin", message: "\n\(error?.localizedDescription ?? "can't post")")
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
    
    func updateExistedSpot(postLocationData: PostLocation) {
        if studentLocArray!.isEmpty { return }
        UdacityAPI.putStudentLocation(objectID: (studentLocArray?[0].objectId)!, postLocation: postLocationData) { (success, error) in
            if error  != nil{
                self.showAlert(title: "can't post new pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post")")
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
    
    
    
    
    
}

extension VerifiedLocationViewController: MKMapViewDelegate {
    
    func addLocation(coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location
        let mapRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(mapRegion, animated: true)
            self.mapView.regionThatFits(mapRegion)
        }
    }
    
}
