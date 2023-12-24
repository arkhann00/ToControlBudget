//
//  CostTableViewCell.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 08.12.2023.
//

import UIKit
import SnapKit

final class CostTableViewCell: UITableViewCell {
    
    let costLabel = UILabel()
    let descriptionTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        backgroundColor = Colors().dark2
        
        addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(frame.width/2)
        }
        costLabel.backgroundColor = .clear
        costLabel.textColor = Colors().green
        costLabel.textAlignment = .left
        costLabel.font = costLabel.font.withSize(frame.height*4/7)
        costLabel.adjustsFontSizeToFitWidth = true
        addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(10)
            make.left.equalTo(costLabel.snp.right).offset(20)
            make.height.greaterThanOrEqualToSuperview()
        }
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = Colors().green
        descriptionTextView.textAlignment = .natural
        descriptionTextView.font = UIFont.systemFont(ofSize: 19)
        
    }
    
    
}
