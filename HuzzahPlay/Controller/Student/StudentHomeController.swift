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
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 100)
        mainLabel.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 32, paddingRight: 32)
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
        
        print("DEBUG: \(student)")
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        label.adjustsFontForContentSizeCategory = true

        mainLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        mainLabel.adjustsFontForContentSizeCategory = true
    
    }
}


