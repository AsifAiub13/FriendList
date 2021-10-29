//
//  FriendViewModel.swift
//  FriendList
//
//  Created by Asif on 10/28/21.
//

import Foundation
protocol DoctorViewModelDelegate {
    func fetchDoctorList(inDocArray:[FriendViewModel], fetchedByAPI:Bool)
}


class FriendViewModel: NSObject {
    
    var nameTitle:String?
    var nameFirst:String?
    var nameLast:String?
    var email: String?
    var cellPhone:String?
    var city:String?
    var state:String?
    var country:String?
    var imageUrl:String?
    var streetName:String?
    var streetNumber:String?
    var gender:String?
    var nat:String?
    
    var docDel:DoctorViewModelDelegate?
    
    func fetchDoctorList(ofFilter:AppConfigs.FilterTypes){
        APIManager.shared.getFriends(ofFilter:ofFilter) { success, error, responseValue in
            self.docDel?.fetchDoctorList(inDocArray: responseValue, fetchedByAPI: true)
        }
        return
    }
    
}
