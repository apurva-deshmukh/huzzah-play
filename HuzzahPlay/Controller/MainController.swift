//
//  MainController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit
import Firebase

class MainController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //presentWelcomeScreen()
        
        if (Auth.auth().currentUser?.uid == nil) {
            presentWelcomeScreen()
        } else {
            fetchUser()
        }
        
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        StudentService.shared.fetchStudent(withUid: currentUid) { (student) in
            self.student = student
            self.presentStudentHomeScreen()
        }
    }
    
    // MARK: - Lifecycle
    
    func presentWelcomeScreen() {
        DispatchQueue.main.async {
            let controller = WelcomeController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func presentStudentHomeScreen() {
        guard let student = student else { return }
        print("DEBUG: main \(student)")
        DispatchQueue.main.async {
            let controller = StudentHomeController(student: student)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
