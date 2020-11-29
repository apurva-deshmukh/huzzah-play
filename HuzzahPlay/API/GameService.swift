//
//  GameService.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import FirebaseFirestore
import Firebase

struct GameService {
    
    static let shared = GameService()
    
    func uploadSentence(_ text: String, from student: Student, to partner: Student, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["sentence": text,
                    "fromId": currentUid,
                    "toId": partner.uid,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_GAMES.document(currentUid).collection(partner.uid).addDocument(data: data) { (_) in
            COLLECTION_GAMES.document(partner.uid).collection(currentUid).addDocument(data: data) { (error) in
                self.fetchSentences(from: student, to: partner) { (story) in
                    var mutStory = story
                    mutStory.sentences.append(text)
                    let sentences = ["sentences": mutStory.sentences] as [String: [String]]
                    COLLECTION_GAMES.document(currentUid).collection(partner.uid).document("story").setData(sentences)
                    COLLECTION_GAMES.document(partner.uid).collection(currentUid).document("story").setData(sentences)
                }
            }
            
            COLLECTION_SESSIONS.document(SESSION).collection("games").document(currentUid).collection(partner.uid).addDocument(data: data) { (_) in
                COLLECTION_SESSIONS.document(SESSION).collection("games").document(partner.uid).collection(currentUid).addDocument(data: data, completion: completion)
            }
        }
        
        
    }
    
    func fetchSentences(from student: Student, to partner: Student, completion: @escaping(Story) -> Void) {
        COLLECTION_GAMES.document(student.uid).collection(partner.uid).document("story").getDocument { (snapshot, error) in
            if let data = snapshot?.data() {
                print("DEBUG: \(data)")
                let sentences = Story(firstStudent: student, secondStudent: partner, dictionary: data)
                completion(sentences)
            } else {
                let sentences = Story(firstStudent: student, secondStudent: partner)
                completion(sentences)
            }
        }
    }
    
    func fetchLatestSentence(from partner: Student, completion: @escaping(String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_GAMES.document(uid).collection(partner.uid).document("story")
        
        query.addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            guard let sentences = data["sentences"] as? [String] else {
                print("DEBUG: error saving as string array")
                return
            }
            guard let last = sentences.last else { return }
            print("DEBUG: \(last)")
            completion(last)
        }
    }
    
    func fetchStory(to student: Student, from partner: Student, completion: @escaping(String) -> Void) {
        
        let query = COLLECTION_GAMES.document(student.uid).collection(partner.uid).document("story")
        query.addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            guard let sentences = data["sentences"] as? [String] else {
                print("DEBUG: error saving as string array")
                return
            }
            
            var isFirstWord = true
            var story = ""
            
            for str in sentences {
                if (isFirstWord) {
                    story = str
                    isFirstWord = false
                } else {
                    story += " \(str)"
                }
            }
            print("DEBUG: \(story)")
            completion(story)
        }
    }
    
}
