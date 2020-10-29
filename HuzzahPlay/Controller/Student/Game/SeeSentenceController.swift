//
//  SeeSentenceController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit

class SeeSentenceController: UIViewController {
    
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
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let storyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Our story so far:"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let sentenceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let storyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        return view
    }()
    
    var sentence: String
    
    // MARK: - Lifecycle
    
    init(student: Student, partner: Student, sentence: String) {
        self.student = student
        self.partner = partner
        self.sentence = sentence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchStory()
        view.addSubview(headerView)
        view.addSubview(sentenceLabel)
        view.addSubview(mainLabel)
        view.addSubview(underlineView)
        view.addSubview(storyLabel)
        view.addSubview(storyTitleLabel)
        view.addSubview(nextButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 100)
        mainLabel.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 30, paddingLeft: 32, paddingRight: 32)
        sentenceLabel.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        underlineView.anchor(top: sentenceLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 5)
        storyTitleLabel.anchor(top: sentenceLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                               paddingTop: 40, paddingLeft: 32, paddingRight: 32)
        storyLabel.anchor(top: storyTitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                          paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
        
    }
    
    // MARK: - API
    func fetchStory() {
        GameService.shared.fetchStory(to: student, from: partner) { (story) in
            print("DEBUG: story in controller is \(story)")
            self.storyLabel.text = story
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func didTapButton() {
        if (student.sentences.count < 3) {
            let controller = InputController(student: student, partner: partner)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FinishedController(student: student, partner: partner)
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
        
        label.text = "ROUND \(student.sentences.count+1)"
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        label.adjustsFontForContentSizeCategory = true
        
        sentenceLabel.text = "\"\(self.sentence)\""
        sentenceLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        sentenceLabel.adjustsFontForContentSizeCategory = true
        
        storyLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        storyLabel.adjustsFontForContentSizeCategory = true
        
        storyTitleLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(40)
        storyTitleLabel.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        mainLabel.text = "\(partner.firstName) wrote:"
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(50)
        mainLabel.adjustsFontForContentSizeCategory = true
    }
}
