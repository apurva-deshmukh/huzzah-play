//
//  StudentLoginController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit
import Firebase

class StudentLoginController: UIViewController {
    
    // MARK: - Properties
    
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
        label.text = "First, let's log in!"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(textField: emailTextField)
    }()
    
    private lazy var passwordContainerView: UIView = {
        return InputContainerView(textField: passwordTextField)
    }()
    
    private let emailTextField: UITextField = {
        return CustomTextField(placeholder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Invite Code")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Me In!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 150)
    }
    
    // MARK: - Selectors
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func didTapLogIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            guard let uid = result?.user.uid else { return }
            StudentService.shared.fetchStudent(withUid: uid) { (student) in
                let controller = StudentWelcomeController(student: student)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
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
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(40)
        label.adjustsFontForContentSizeCategory = true
        
        loginButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(20)
        loginButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        let bufferView = UIView()
        bufferView.backgroundColor = .primary
        bufferView.setHeight(height: 100)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, bufferView, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                     paddingLeft: 32, paddingBottom: 120, paddingRight: 32)
    }
    
}
