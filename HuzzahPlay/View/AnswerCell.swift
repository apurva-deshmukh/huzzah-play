//
//  AnswerCell.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    // MARK: - Properties
    
    var answer: String? {
        didSet {
            configureCell()
        }
    }
    
    var chosen: Bool = false;
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .light
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configureCell() {
        guard let answer = answer else { return }
        guard let customFont = UIFont(name: "GloriaHallelujah", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        backgroundColor = isSelected ? .secondary : .primary
        
        answerLabel.text = answer
        answerLabel.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(30)
        answerLabel.adjustsFontForContentSizeCategory = true
        
        addSubview(answerLabel)
        answerLabel.center(inView: self)
    }
    
    
}
