//
//  MainController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

class MainController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in main controller")
        presentWelcomeScreen()
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
}
