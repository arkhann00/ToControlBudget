//
//  BudgetLabel.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import UIKit

final class BudgetLabel:UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        backgroundColor = Colors().dark3
        text = "Non value"
        font = font.withSize(30)
        textColor = Colors().green
        layer.cornerRadius = 20
        textAlignment = .right
        layer.masksToBounds = true
        adjustsFontSizeToFitWidth = true
    }
    
}
