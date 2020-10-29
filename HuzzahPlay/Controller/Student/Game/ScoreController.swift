//
//  ScoreController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit

class ScoreController: UIViewController {
    
    // MARK: - Properties
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Great Job!"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back to home screen", for: .normal)
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

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addSubview(headerView)
        view.addSubview(imageView)
        view.addSubview(button)
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                          paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 200)
        imageView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height-450)
        button.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 50, paddingRight: 50)
    }
    
    // MARK: - Selectors
    
    @objc func didTapGetStarted() {
        navigationController?.popToRootViewController(animated: true)
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
