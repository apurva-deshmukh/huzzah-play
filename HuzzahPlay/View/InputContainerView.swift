//
//  InputContainerView.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

class InputContainerView: UIView {

    // MARK: - Lifecycle
    
    init(textField: UITextField) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 10)
        
        backgroundColor = .light
        layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
