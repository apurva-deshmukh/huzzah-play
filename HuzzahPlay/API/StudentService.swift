//
//  StudentService.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/3/20.
//

import FirebaseFirestore
import Firebase

struct StudentService {
    
    static let shared = StudentService()
    
    func fetchStudent(withUid uid: String, completion: @escaping(Student) -> Void) {
        COLLECTION_STUDENTS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = Student(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func uploadAnswers(student: Student, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["answers": student.answers,
                    "first-name": student.firstName,
                    "last-name": student.lastName,
                    "email": student.email] as [String: Any]
         
        COLLECTION_STUDENTS.document(uid).setData(data)
    }
    
}
