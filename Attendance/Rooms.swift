//
//  Rooms.swift
//  Attendance
//
//  Created by Mac on 2021/02/27.
//

import Foundation
import Firebase

class Rooms{
    
    let roomName: String!
    let roomNumber: String!
    let enterUser: String!
    let enterName: String!
    let userId: String!
    let roomEnterNum: String!
    let iconName: String!
    var iconNameArray = [String]()
    
    init(document: QueryDocumentSnapshot) {
    
        let Dic = document.data()
        self.roomName = Dic["roomName"] as? String ?? ""
        self.roomNumber = Dic["roomNumber"] as? String ?? ""
        self.enterUser = Dic["enterUserID"] as? String ?? ""
        self.enterName = Dic["enterUserName"] as? String ?? ""
        self.userId = Dic["uid"] as? String ?? ""
        self.roomEnterNum = Dic["roomEnterNum"] as? String ?? ""
        self.iconName = Dic["iconName"] as? String ?? ""
        self.iconNameArray = Dic["iconNameArray"] as? [String] ?? []
        //print("Dic\(self.iconNameArray)")
    }
}
