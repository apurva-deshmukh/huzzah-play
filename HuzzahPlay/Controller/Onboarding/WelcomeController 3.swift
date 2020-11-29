//
//  WelcomeController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

class WelcomeController: UIViewController {
    
    // MARK: - Properties
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Welcome to HuzzahPlay!"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Let's get started!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapGetStarted), for: .touchUpInside)
        return button
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "kid").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark
        view.layer.cornerRadius = 50
        view.addSubview(label)
        label.centerY(inView: view)
        label.anchor(left: view.leftAnchor, right: view.rightAnchor)
        return view
    }()
    
    private let teacherSignInButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Are you a teacher? ",
                                                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                     NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign in here",
                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
                                                               NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapTeacherSignIn), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addSubview(headerView)
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(teacherSignInButton)
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, height: 200)
        imageView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height-450)
        button.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 50, paddingRight: 50)
        teacherSignInButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                   paddingLeft: 32, paddingRight: 32)
    }
    
    // MARK: - Selectors
    
    @objc func didTapGetStarted() {
        let controller = StudentLoginController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func didTapTeacherSignIn() {
        print("DEBUG: tapped teacher sign in")
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
        
        button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(20)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(50)
        label.adjustsFontForContentSizeCategory = true
    }
}

