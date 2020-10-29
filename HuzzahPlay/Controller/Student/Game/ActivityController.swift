//
//  ActivityController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/4/20.
//

import UIKit

class ActivityController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student
    var partner: Student
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        view.layer.cornerRadius = 5
        view.addSubview(label)
        label.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                     right: view.rightAnchor, paddingBottom: 10)
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Today's Activity: Storytelling!"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Based on the topic below, please take turns writing a creative story with your partner!"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "Ronald and Janet look into the closet and gasp..."
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "activity").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start the story!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(student: Student, partner: Student) {
        self.student = student
        self.partner = partner
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        view.addSubview(mainLabel)
        view.addSubview(imageView)
        view.addSubview(promptLabel)
        view.addSubview(nextButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 100)
        mainLabel.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        imageView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor,
                         right: view.rightAnchor, height: view.frame.height-450)
        promptLabel.center(inView: view)
        promptLabel.setWidth(width: view.frame.width-150)
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
    }
    
    // MARK: - Selectors
    
    @objc func didTapNext() {
        if (student.isFirst) {
            let controller = InputController(student: student, partner: partner)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = LoadingController(student: student, partner: partner)
            navigationController?.pushViewController(controller, animated: true)
        }
       
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
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(20)
        label.adjustsFontForContentSizeCategory = true
        
        promptLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        promptLabel.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(22)
        mainLabel.adjustsFontForContentSizeCategory = true
    }
}
