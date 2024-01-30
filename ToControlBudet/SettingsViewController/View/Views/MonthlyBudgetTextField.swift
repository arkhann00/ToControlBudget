//
//  MonthlyBudgetTextField.swift
//  ToControlBudet
//
//  Created by Khachatryan Arsen on 29.01.2024.
//

import UIKit

class MonthlyBudgetTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        backgroundColor = Colors().dark4
        placeholder = "Add monthly budget"
        layer.masksToBounds = true
        layer.cornerRadius = 8
        textColor = Colors().green
        keyboardType = .decimalPad
    }
    
}
