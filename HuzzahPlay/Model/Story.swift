//
//  Story.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import Foundation

struct Story {
    
    var sentences: [String]
    let firstStudent: Student
    let secondStudent: Student
    
    init(firstStudent: Student, secondStudent: Student, dictionary: [String: Any]) {
        self.sentences = dictionary["sentences"] as? [String] ?? [String]()
        self.firstStudent = firstStudent
        self.secondStudent = secondStudent
    }
    
    init(firstStudent: Student, secondStudent: Student) {
        self.firstStudent = firstStudent
        self.secondStudent = secondStudent
        self.sentences = [String]()
    }
}
