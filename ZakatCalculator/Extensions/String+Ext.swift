//
//  String+Ext.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 18/05/26.
//

import Foundation

extension String {
    
    var localized: String {
        LocalizationManager.shared.localizedString(for: self)
    }
}
