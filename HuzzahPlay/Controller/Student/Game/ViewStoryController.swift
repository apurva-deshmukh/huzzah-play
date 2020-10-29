//
//  ViewStoryController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit
import Firebase

class ViewStoryController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student
    var partner: Student
    var story: String
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DONE", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(student: Student, partner: Student, story: String) {
        self.student = student
        self.partner = partner
        self.story = story
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        
        view.addSubview(mainLabel)
        view.addSubview(nextButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainLabel.center(inView: view)
        mainLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
    }

    
    // MARK: - Selectors
    
    @objc func didTapNext() {
        do {
            try Auth.auth().signOut()
            let controller = ScoreController()
            navigationController?.pushViewController(controller, animated: true)
        } catch {
            print("DEBUG: Error signing out")
        }
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        guard let customFont = UIFont(name: "GloriaHallelujah", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        mainLabel.text = story
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        mainLabel.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
