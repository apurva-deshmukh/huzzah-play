//
//  FirstQuestionController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

private let reuseIdentifier = "AnswerCell"

class FirstQuestionController: UIViewController {
    
    // MARK: - Properties
    
    private let answerChoices = ["Invisibility", "Flying", "Super Speed", "Mind Control"]
    
    var selectedString: String?
    
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
        label.text = "Which superpower do you wish you had?"
        label.textColor = .light
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        return tv
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.light, for: .normal)
        button.backgroundColor = .secondary
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    var student: Student
    
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
        view.addSubview(tableView)
        view.addSubview(nextButton)
        configureTableView()
        
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                          paddingTop: 50, paddingLeft: 20, paddingRight: 20, height: 150)
        nextButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 50, paddingBottom: 50, paddingRight: 50)
        tableView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: nextButton.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingBottom: 20, width: view.frame.width)
    }
    
    // MARK: - Selectors
    
    @objc func didTapNext() {
        guard let selectedString = selectedString else { return }
        student.answers.append(selectedString)
        let controller = SecondQuestionController(student: student)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        tableView.backgroundColor = .primary
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnswerCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
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
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        label.adjustsFontForContentSizeCategory = true
        
        nextButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        nextButton.titleLabel?.adjustsFontForContentSizeCategory = true

    }

}

extension FirstQuestionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerChoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AnswerCell
        cell.answer = answerChoices[indexPath.row]
        return cell
    }
    
}

extension FirstQuestionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: did select \(answerChoices[indexPath.row])")
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .secondary
        }
        selectedString = answerChoices[indexPath.row]
    }
}

