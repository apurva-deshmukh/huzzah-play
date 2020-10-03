//
//  StudentWelcomeController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

class StudentWelcomeController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        view.layer.cornerRadius = 20
        view.addSubview(label)
        label.centerY(inView: view)
        label.anchor(left: view.leftAnchor, right: view.rightAnchor)
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's answer a few questions about you!"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        view.addSubview(mainLabel)
        view.addSubview(continueButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 150)
        mainLabel.centerY(inView: view)
        mainLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        continueButton.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 150, paddingLeft: 50, paddingRight: 50)
    }
    
    // MARK: - Selectors
    
    @objc func didTapContinue() {
        let controller = FirstQuestionController(student: student)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .primary
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        guard let customFont = UIFont(name: "GloriaHallelujah", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.text = "Welcome back, \(student.firstName)!"
        let answers = [String]()
        student.answers = answers
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        label.adjustsFontForContentSizeCategory = true

        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        mainLabel.adjustsFontForContentSizeCategory = true
        
        continueButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(20)
        continueButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
