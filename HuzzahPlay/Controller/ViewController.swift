//
//  WelcomeController.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/2/20.
//

import UIKit

class WelcomeController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        
        view.backgroundColor = .primary
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        guard let customFont = UIFont(name: "GloriaHallelujah", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: customFont).withSize(50)
        label.adjustsFontForContentSizeCategory = true
        
        view.addSubview(label)
        label.center(inView: view)
    }
}

