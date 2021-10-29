//
//  AppConfigs.swift
//  FriendList
//
//  Created by Asif on 10/28/21.
//

import Foundation

class AppConfigs: NSObject {
    
    static let BaseUrl = "https://randomuser.me"
    
    static let Friendcity = "city"
    static let Friendstate = "state"
    static let FriendstreetName = "name"
    static let FriendstreetNumber = "number"
    static let FriendcellPhone = "cell"
    static let Friendemail = "email"
    static let FriendnameLast = "last"
    static let FriendnameTitle = "title"
    static let FriendnameFirst = "first"
    static let Friendcountry = "country"
    static let FriendimageUrl = "large"
    static let Friendgender = "gender"
    static let Friendnat = "nat"
    
    static let DBEntityName = "Friend"
    static let FilterArray = ["All", "Male", "Female"]
    
    enum FilterTypes:String {
        case All
        case Male
        case Female
    }
}
