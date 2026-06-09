//
//  ZCInfoButton.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 25/05/26.
//

import UIKit

class ZCInfoButton: UIButton {
    
    private var infoMessage = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(message: String) {
        super.init(frame: .zero)
        self.infoMessage = message
        configure()
        setupMenu()
    }
    
    
    private func configure() {
        let config      = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let iconImage   = UIImage(systemName: "info.circle", withConfiguration: config)
        
        setImage(iconImage, for: .normal)
        tintColor       = .systemGray2
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupMenu() {
        let dismissAction = UIAction(title: "                 Got it") { _ in }
        
        let infoMenu    = UIMenu(title: infoMessage, children: [dismissAction])
        self.menu       = infoMenu
        self.showsMenuAsPrimaryAction   = true
    }
}
