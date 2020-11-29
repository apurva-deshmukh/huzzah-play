//
//  Session.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 11/29/20.
//

import SwiftyJSON

struct Session {
    var groups = [Group]()
    
    init(json: JSON) {
        for (_, subJson) in json {
            groups.append(Group(json: subJson))
        }
    }
}
