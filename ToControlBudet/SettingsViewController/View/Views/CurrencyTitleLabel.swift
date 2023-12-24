//
//  CurrencyTitleLabel.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 21.12.2023.
//

import UIKit

final class CurrencyTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        text = "Change currency"
        textColor = Colors().green
        backgroundColor = .clear
        font = font.withSize(15)
        textAlignment = .left
        
    }
    
}
