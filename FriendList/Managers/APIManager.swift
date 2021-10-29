//
//  APIManager.swift
//  FriendList
//
//  Created by Asif on 10/28/21.
//

import Foundation
import UIKit

class APIManager: NSObject {

    static let shared = APIManager()
    
    enum ApiResult {
        case Successful
        case Failed
    }
    
    
    
    
    
    var API_BASE_URL = "https://randomuser.me"
    typealias CompletionHandler = (_ success:Bool, _ error:Error?, _ responseValue:[FriendViewModel]) -> Void

    var arr = [FriendViewModel]()
    
    func getFriends(ofFilter:AppConfigs.FilterTypes, completion: @escaping CompletionHandler){
        
        var url = URL(string: API_BASE_URL + "/api/?inc=name,nat,location,email,cell,picture,gender&results=20")
        
        if ofFilter == .Female{
            url = URL(string: API_BASE_URL + "/api/?inc=name,nat,location,email,cell,picture,gender&results=20&gender=female")
        }else if ofFilter == .Male{
            url = URL(string: API_BASE_URL + "/api/?inc=name,nat,location,email,cell,picture,gender&results=20&gender=male")
        }else{
            url = URL(string: API_BASE_URL + "/api/?inc=name,nat,location,email,cell,picture,gender&results=20")
        }
        
        let request = NSMutableURLRequest(url:url!)
    
        request.httpMethod = "GET"
        request.timeoutInterval = 40.0
        let session = URLSession.shared
        self.arr.removeAll()
        let task = session.dataTask(with: request as URLRequest) { (data, response, err) in
            if err != nil {
                completion(false,err,self.arr)
                return
            }
            
            if let recievedData = data{
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: recievedData, options: .allowFragments) as? NSDictionary
                    if let dataDictArr = jsonData?.object(forKey: "results") as? [NSDictionary]{
                        if dataDictArr.count != 0{
                            for single in dataDictArr {
                                print(single)
                                
                                let nameDict = single["name"] as! NSDictionary
                                let locationDict = single["location"] as! NSDictionary
                                let streetDict = locationDict["street"] as! NSDictionary
                                let pictureDict = single["picture"] as! NSDictionary
                                
                                let obj = FriendViewModel()
                                
                                obj.city = locationDict["city"] as? String
                                obj.state = locationDict["state"] as? String
                                obj.streetName = streetDict["name"] as? String
                                obj.streetNumber = streetDict["number"] as? String
                                obj.cellPhone = single["cell"] as? String
                                obj.email = single["email"] as? String
                                obj.nameLast = nameDict["last"] as? String
                                obj.nameTitle = nameDict["title"] as? String
                                obj.nameFirst = nameDict["first"] as? String
                                obj.country = locationDict["country"] as? String
                                obj.imageUrl = pictureDict["large"] as? String
                                obj.gender = single["gender"] as? String
                                obj.nat = single["nat"] as? String
                                
                                self.arr.append(obj)
                            }
                        }
                    }
                    
                    
                    completion(true,nil,self.arr)
                }
                catch{
                    completion(false,nil,self.arr)
                    return
                }
            }
        }
        task.resume()
        
    }
    
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
