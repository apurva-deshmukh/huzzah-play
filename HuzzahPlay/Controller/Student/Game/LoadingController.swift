//
//  LoadingController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit

class LoadingController: UIViewController {
    
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
        label.text = "Your turn! Enter your sentence!"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See partner's sentence", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .dark
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    var sentence: String?
    
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
        view.addSubview(nextButton)
        
        configureUI()
        fetchPartnerSentence()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 100)
        mainLabel.centerY(inView: view)
        mainLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
    }
    
    // MARK: - API
    
    func fetchPartnerSentence() {
        GameService.shared.fetchLatestSentence(from: partner) { (sentence) in
            if sentence != self.student.sentences.last && sentence != "" {
                print("DEBUG: in controller \(sentence)")
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = .secondary
                self.sentence = sentence
                self.partner.sentences.append(sentence)
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func didTapButton() {
        guard let sentence = sentence else { return }
        let controller = SeeSentenceController(student: student, partner: partner, sentence: sentence)
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
        
        label.text = "ROUND \(student.sentences.count+1)"
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        label.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        mainLabel.text = "\(partner.firstName)'s Turn!"
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(50)
        mainLabel.adjustsFontForContentSizeCategory = true
    }
}
