//
//  InputController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit

class InputController: UIViewController {
    
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
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        return button
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Your turn! Enter your sentence!"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let textView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderLabel.text = "Your turn! Enter your sentence!"
        tv.backgroundColor = .light
        tv.textColor = .dark
        tv.layer.cornerRadius = 10
        return tv
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
        view.addSubview(textView)
        view.addSubview(nextButton)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 100)
        mainLabel.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
        textView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, bottom: nextButton.topAnchor, right: view.rightAnchor,
                        paddingTop: 20, paddingLeft: 32, paddingBottom: 50, paddingRight: 32)
        
    }
    
    // MARK: - Selectors
    
    @objc func didTapSend() {
        guard let text = textView.text else { return }
        textView.resignFirstResponder()
        student.sentences.append(text)
        GameService.shared.uploadSentence(text, from: student, to: partner) { (error) in
            if let error = error {
                print("DEBUG: error uploading sentence - \(error.localizedDescription)")
                return
            }
            if (self.partner.sentences.count < 3) {
                let controller = LoadingController(student: self.student, partner: self.partner)
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let controller = FinishedController(student: self.student, partner: self.partner)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .primary
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
        
        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(22)
        mainLabel.adjustsFontForContentSizeCategory = true
    }
}
