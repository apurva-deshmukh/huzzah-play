//
//  Student.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/3/20.
//

struct Student {
    
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    var answers: [String]
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.firstName = dictionary["first-name"] as? String ?? ""
        self.lastName = dictionary["last-name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        self.answers = dictionary["answers"] as? [String] ?? [String]()
    }
    
}
