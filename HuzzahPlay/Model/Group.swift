//
//  Group.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 11/29/20.
//

import SwiftyJSON

struct Group {
    
    let uid1: String
    let uid2: String

    init(json: JSON) {
        self.uid1 = json["uid1"].stringValue
        self.uid2 = json["uid2"].stringValue
    }
    
}
