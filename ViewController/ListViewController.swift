//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Shahad on 24/03/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ListViewController : UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var refreshControl = UIRefreshControl()
    
    var studentArray = [StudentLocation]()
    var recordNum: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refresh()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // get student location
        self.recordNum = SLocationData.studentsData.count
        self.refresh()
        
    }

    
    @IBAction func addLocation(_ sender: Any) {
        activityIndicator.startAnimating()
        let alertVC = UIAlertController(title: "Warning!", message: "You've already put your pin on the map.\nWould you like to overwrite it?", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (_) in
            self.performSegue(withIdentifier: "addSpot", sender: (true, self.studentArray))
            
        }))
        
        alertVC.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
    
        @objc func refresh() {
        
        UdacityAPI.getStudentLocation(singleStudent: false, completion:{ (data, error) in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "")
                return
            }
            SLocationData.studentsData = data
            self.studentArray.removeAll()
            self.studentArray.append(contentsOf: SLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        })}
    
    func getStudentData() {
        UdacityAPI.getStudentLocation(singleStudent: false, completion:{ (data, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                SLocationData.studentsData = data
                self.studentArray.removeAll()
                self.studentArray.append(contentsOf: SLocationData.studentsData.sorted(by: {$0.updatedAt > $1.updatedAt}))
                self.tableView.reloadData()
            }})}

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addSpot" {
            let controller = segue.destination as! NewLocationViewController
            let updateFlag = sender as? (Bool, [StudentLocation])
            controller.updatePin = updateFlag?.0
            controller.studentArr = updateFlag?.1
        }
    }
    
    
    
    
}
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "tableCell" )!
        let list = studentArray[indexPath.row]
        cell.textLabel?.text = list.firstName + " " + list.lastName
        cell.detailTextLabel?.text = list.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin.png")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        app.open(URL(string: studentArray[indexPath.row].mediaURL) ?? URL(string: "")!, options: [:], completionHandler: nil)
    }
    
}
