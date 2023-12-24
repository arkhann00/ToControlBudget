//
//  CostsTableView.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import UIKit

final class CostsTableView:UITableView{
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        backgroundColor = Colors().dark3
        layer.masksToBounds = true
        layer.cornerRadius = 20
                
    }
    
}

