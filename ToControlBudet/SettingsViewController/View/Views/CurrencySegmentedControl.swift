//
//  CurrencySegmentedControl.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 21.12.2023.
//

import UIKit

final class CurrencySegmentedControl:UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        backgroundColor = Colors().dark1
        selectedSegmentTintColor = Colors().dark2
        isSelected = true
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor:Colors().green], for: .normal)
        
    }
    
}
