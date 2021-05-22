//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation
import UIKit

class TableViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var studentListTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshTable: UIBarButtonItem!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var students = [LocationsResponse]()
    
    
    override func viewDidLoad() {
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(self.view)
        activityIndicator.center = self.view.center
        setActivityIndicator(myIndicator: activityIndicator, status: "Show")
        
        
        studentListTableView.dataSource = self
        studentListTableView.delegate = self
        self.studentListTableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.studentListTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentList()
        self.studentListTableView.reloadData()
    }
    
    func getStudentList() {
        setActivityIndicator(myIndicator: activityIndicator, status: "Show")
        UdacityClient.getStudentLocations { (students, error) in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.studentListTableView.reloadData()
                self.setActivityIndicator(myIndicator: self.activityIndicator, status: "Hide")
            }
        }
    }
    
    // MARK: Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(students.count)
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentListCell", for: indexPath)
        let student = students[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(student.firstName ?? "") \(student.lastName ?? "")"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    // MARK: Logout Button
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        setActivityIndicator(myIndicator: activityIndicator, status: "Show")
        UdacityClient.logout {
            DispatchQueue.main.async { [self] in
                self.dismiss(animated: true, completion: nil)
                self.setActivityIndicator(myIndicator: self.activityIndicator, status: "Hide")
            }
        }
    }
    @IBAction func refreshTableTapped(_ sender: Any) {
        getStudentList()
    }
    
    // MARK: Activity Indicator Settings
    func setActivityIndicator(myIndicator: UIActivityIndicatorView, status: String) {
        if status == "Show" {
            myIndicator.isHidden = false
            myIndicator.startAnimating()
        } else {
            myIndicator.isHidden = true
            myIndicator.stopAnimating()
        }
    }

}
