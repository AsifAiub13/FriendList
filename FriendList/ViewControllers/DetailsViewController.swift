//
//  DetailsViewController.swift
//  FriendList
//
//  Created by Asif on 10/29/21.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailsTableView: UITableView!
    
    @IBOutlet weak var friendImgView: UIImageView!
    
    var favPressed = false
    
    var passedObject:FriendViewModel?
    
    var leftLabelsArray = ["Full Name","Address", "City", "State", "Country", "Email", "Cell Phone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var fullName = "\(self.passedObject?.nameTitle ?? "")"
        fullName += " \(self.passedObject?.nameFirst ?? "")"
        fullName += " \(self.passedObject?.nameLast ?? "")"
        self.title = fullName
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.friendImgView.loadImageUsingCache(withUrl: (passedObject?.imageUrl)!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftLabelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsTableCell", for: indexPath)
        cell.textLabel?.text = leftLabelsArray[indexPath.row]
        
        switch indexPath.row {
        case 0://full name
            var fullName = "\(passedObject?.nameTitle ?? "")"
            fullName += " \(passedObject?.nameFirst ?? "")"
            fullName += " \(passedObject?.nameLast ?? "")"
            cell.detailTextLabel?.text = fullName
        case 1://address
            var fullAddress = ""
            if passedObject?.streetNumber == "" || passedObject?.streetNumber == nil{
                fullAddress = passedObject?.streetName ?? ""
            }else{
                fullAddress = "\(passedObject?.streetNumber ?? "")"
                fullAddress += ", \(passedObject?.streetName ?? "")"
            }
            
            cell.detailTextLabel?.text = fullAddress
        case 2://city
            cell.detailTextLabel?.text = passedObject?.city
        case 3://state
            cell.detailTextLabel?.text = passedObject?.state
        case 4://country
            cell.detailTextLabel?.text = passedObject?.country
        case 5://email
            cell.detailTextLabel?.text = passedObject?.email
        case 6://cell
            cell.detailTextLabel?.text = passedObject?.cellPhone
        default:
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "detailsTableCell") {
                if let callUrl = URL(string: "\(cell.detailTextLabel?.text ?? "")"), UIApplication.shared.canOpenURL(callUrl) {
                    UIApplication.shared.open(callUrl)
                }
            }
        }
        if indexPath.row == 5{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "detailsTableCell") {
                let email = cell.detailTextLabel?.text ?? ""
                if let url = URL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url)
                }
            }
        }    
    }
    

}
