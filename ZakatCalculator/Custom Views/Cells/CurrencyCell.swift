//
//  CurrencyCell.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 08/06/26.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    static let reuseID  = "CurrencyCell"
    let contatinerView  = UIView()
    let currencyLabel   = ZCTitleLabel(textAlignment: .center, fontSize: 18)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.addSubview(contatinerView)
        contatinerView.addSubview(currencyLabel)
        
        contatinerView.translatesAutoresizingMaskIntoConstraints = false
        
        contatinerView.layer.cornerRadius  = 12
        contatinerView.backgroundColor     = .systemGroupedBackground
        contatinerView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            contatinerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contatinerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contatinerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contatinerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            currencyLabel.centerYAnchor.constraint(equalTo: contatinerView.centerYAnchor),
            currencyLabel.centerXAnchor.constraint(equalTo: contatinerView.centerXAnchor)
        ])
    }
    
    
    func set(currencyLabel: String, isActive: Bool) {
        self.currencyLabel.text             = currencyLabel
        self.contatinerView.backgroundColor = isActive ? Colors.green : .systemGroupedBackground
        self.currencyLabel.textColor        = isActive ? UIColor.white : .label
    }
}
