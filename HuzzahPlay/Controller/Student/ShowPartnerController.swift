//
//  ShowPartnerController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/4/20.
//

import UIKit

class ShowPartnerController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student
    var otherStudents: [Student]?
    
    var partner: Student?
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your partner is..."
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        view.layer.cornerRadius = 20
        view.addSubview(label)
        label.centerY(inView: view)
        label.anchor(left: view.leftAnchor, right: view.rightAnchor)
        view.layer.borderWidth = 1
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start the game!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
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
        view.backgroundColor = .primary
        
        view.addSubview(mainLabel)
        view.addSubview(nameView)
        view.addSubview(nextButton)
        
        configureUI()
        fetchOtherUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 100, paddingLeft: 32, paddingRight: 32)
        nameView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                        paddingTop: 30, paddingLeft: 50, paddingRight: 50, height: 150)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
    }
    
    func fetchOtherUsers() {
//        StudentService.shared.fetchStudents { [weak self] (students) in
//            self?.otherStudents = students
//            self?.configureText()
//        }
        
        StudentService.shared.fetchPartner { (student) in
            print("Partner name is \(student.firstName)")
            self.partner = student
            self.configureText()
        }
    }
    
    // MARK: - Selectors
    
    @objc func didTapNext() {
        guard let partner = partner else { return }
        let controller = ActivityController(student: student, partner: partner)
        navigationController?.pushViewController(controller, animated: true)
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
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        label.adjustsFontForContentSizeCategory = true
        
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        mainLabel.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func configureText() {
        guard let partner = partner else { return }
        label.text = "\(partner.firstName)!"
    }
}
