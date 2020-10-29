//
//  FinishedController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/6/20.
//

import UIKit

class FinishedController: UIViewController {
    
    // MARK: - Properties
    
    var student: Student
    var partner: Student
    
    private lazy var congratsView: UIView = {
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
        label.text = "Congrats, you are done!"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("VIEW MY STORY!", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    var story: String?
    
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
        view.backgroundColor = .primary
        
        view.addSubview(congratsView)
        view.addSubview(nextButton)
        
        configureUI()
        fetchStory()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        congratsView.center(inView: view)
        congratsView.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 50, paddingRight: 50, height: 200)
        
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
    }
    
    // MARK: - API
    
    func fetchStory() {
        GameService.shared.fetchStory(to: student, from: partner) { (story) in
            print("DEBUG: story in controller is \(story)")
            self.story = story
        }
    }
    
    // MARK: - Selectors
    
    @objc func didTapNext() {
        guard let story = story else { return }
        let controller = ViewStoryController(student: student, partner: partner, story: story)
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
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(40)
        label.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(25)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
}
