//
//  ViewController.swift
//  FriendList
//
//  Created by Asif on 10/28/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DoctorViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var homeSearchBar: UISearchBar!
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var doctorsModelArray:[FriendViewModel]?
    let docModel = FriendViewModel()
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friends"
        
        self.homeSearchBar.delegate = self
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.tableFooterView = UIView()
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        docModel.docDel = self
        docModel.fetchDoctorList(ofFilter: .All)
    }
    
    func fetchDoctorList(inDocArray: [FriendViewModel], fetchedByAPI: Bool) {
        DispatchQueue.main.async {
            self.doctorsModelArray?.removeAll()
            self.showToast(message: "Fetching Data...", seconds: 2.0)
            self.doctorsModelArray = inDocArray
            self.homeTableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorsModelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        var fullName = "\(self.doctorsModelArray?[indexPath.row].nameTitle ?? "")"
        fullName += " \(self.doctorsModelArray?[indexPath.row].nameFirst ?? "")"
        fullName += " \(self.doctorsModelArray?[indexPath.row].nameLast ?? "")"
        
        cell.friendNameLabel.text = fullName
        cell.friendEmailLabel.text = self.doctorsModelArray?[indexPath.row].email
        cell.friendImgView.loadImageUsingCache(withUrl: (self.doctorsModelArray?[indexPath.row].imageUrl)!)
        cell.friendImgView.circularImageView()
        cell.friendCountryLabel.text = self.doctorsModelArray?[indexPath.row].country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theStoryboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let theViewController = theStoryboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        theViewController.passedObject = doctorsModelArray?[indexPath.row]
        self.navigationController?.pushViewController(theViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func buttonRefreshTapped(_ sender: UIBarButtonItem) {
        docModel.fetchDoctorList(ofFilter: .All)
        selectedIndexPath = IndexPath(row: 0, section: 0)
        
        self.filterCollectionView.reloadData()
        
        self.homeSearchBar.text = ""
        self.homeSearchBar.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != nil && searchBar.text != ""{
            let searchText = searchBar.text!.lowercased()
            
            let filteredAircraft = doctorsModelArray?.filter({
                var result = false
                
                var fullName = "\($0.nameTitle ?? "")"
                fullName += " \($0.nameFirst ?? "")"
                fullName += " \($0.nameLast ?? "")"
                
                let trailNum = fullName.lowercased()
                let srnNum = $0.country?.lowercased() ?? ""
                
                result = srnNum.contains(searchText)
                if !result{
                    result = trailNum.contains(searchText)
                }
                return result
                
            })
            doctorsModelArray = filteredAircraft
        }else{
            //doctorsModelArray = DBManager.sharedDB.fetchDocData()
            docModel.fetchDoctorList(ofFilter: .All)
            DispatchQueue.main.async {
                self.filterCollectionView.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition:[])
                UserDefaults.standard.set(0, forKey: "selectedItem")
                self.filterCollectionView.reloadData()
            }
        }
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppConfigs.FilterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell{
            
            cell.connectionView.layer.cornerRadius = cell.connectionView.frame.height/2
            cell.connectionView.layer.masksToBounds = true
            cell.connectionView.layer.borderWidth = 0
            cell.connectionView.layer.borderColor = UIColor.clear.cgColor
            cell.connectionView.layer.shadowColor = UIColor.black.cgColor
            cell.connectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.connectionView.layer.shadowRadius = 3.0
            cell.connectionView.layer.shadowOpacity = 0.5
            cell.connectionView.layer.masksToBounds = false
            cell.connectionNameLabel.text = AppConfigs.FilterArray[indexPath.item]
            
            cell.connectionView.layer.borderColor = UIColor.lightGray.cgColor
            cell.connectionView.layer.borderWidth = 1
            
            if selectedIndexPath == indexPath {
                cell.connectionView.backgroundColor = .gray
            }
            else {
                cell.connectionView.backgroundColor = .black
            }
            if cell.connectionView.backgroundColor == .gray && selectedIndexPath != indexPath{
                cell.connectionView.backgroundColor = .black
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var textSize = AppConfigs.FilterArray[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        textSize.height = 35
        textSize.width = textSize.width + 45
        return textSize
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.connectionView.backgroundColor = .gray
            
            if selectedIndexPath != indexPath{
                selectedIndexPath = indexPath
            }
            
            docModel.fetchDoctorList(ofFilter: AppConfigs.FilterTypes(rawValue: cell.connectionNameLabel.text!) ?? .All)
        }
        self.homeSearchBar.text = ""
        self.homeSearchBar.endEditing(true)
        self.filterCollectionView.reloadData()
    }
    
    
    
}

extension UIViewController{
    func presentViewControllerNamed(viewControllerName:String, of Storyboard:String) {
        let theStoryboard : UIStoryboard = UIStoryboard(name: Storyboard, bundle: nil)
        let theViewController = theStoryboard.instantiateViewController(withIdentifier: viewControllerName)
        theViewController.modalPresentationStyle = .fullScreen
        self.present(theViewController, animated: true)
    }
    
    func pushViewControllerNamed(viewControllerName:String, of Storyboard:String) {
        let theStoryboard : UIStoryboard = UIStoryboard(name: Storyboard, bundle: nil)
        let theViewController = theStoryboard.instantiateViewController(withIdentifier: viewControllerName)
        self.navigationController?.pushViewController(theViewController, animated: true)
    }
    
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .white
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}

extension UIImageView{
    func circularImageView(){
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

