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
            let user = Student(dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchStudents(completion: @escaping([Student]) -> Void) {
        COLLECTION_STUDENTS.getDocuments { (snapshot, error) in
            guard var students = snapshot?.documents.map({ Student(dictionary: $0.data() )}) else { return }
            
            if let i = students.firstIndex(where: { $0.uid == Auth.auth().currentUser?.uid }) {
                print("DEBUG: here in remove")
                students.remove(at: i)
            }
            
            completion(students)
        }
    }
    
    func uploadAnswers(student: Student, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["answers": student.answers,
                    "first-name": student.firstName,
                    "last-name": student.lastName,
                    "email": student.email,
                    "is-first": student.isFirst,
                    "uid": student.uid] as [String: Any]
         
        COLLECTION_STUDENTS.document(uid).setData(data)
    }
    
    func uploadSentence(student: Student, completion: ((Bool) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
//        let data = ["sentences": student.sentences] as [String: Any]
//         
//        COLLECTION_STUDENTS.document(uid).updateData(data)
//        completion(true)
    }
    
}
