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
    
    init(document: QueryDocumentSnapshot) {
    
        let Dic = document.data()
        self.roomName = Dic["roomName"] as? String ?? ""
        self.roomNumber = Dic["roomNumber"] as? String ?? ""
    }
}
