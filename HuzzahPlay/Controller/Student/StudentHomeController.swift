//
//  StudentHomeScreen.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/3/20.
//

import UIKit

class StudentHomeController: UIViewController {
    
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
        label.text = "Great!"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Now roll the dice to see who you'll be buddying up with today!"
        label.numberOfLines = 0
        label.textColor = .dark
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "dice").withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Roll dice!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapRoll), for: .touchUpInside)
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
        view.addSubview(imageView)
        view.addSubview(button)
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 100)
        mainLabel.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 32, paddingRight: 32)
        imageView.anchor(top: mainLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32, height: view.frame.height-500)
        button.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 50, paddingBottom: 30, paddingRight: 50)
        
    }
    
    // MARK: - Selectors
    
    @objc func didTapRoll() {
        let controller = ShowPartnerController(student: student)
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
        
        print("DEBUG: \(student)")
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        label.adjustsFontForContentSizeCategory = true

        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        mainLabel.adjustsFontForContentSizeCategory = true
        
        button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(20)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
    
    }
}


