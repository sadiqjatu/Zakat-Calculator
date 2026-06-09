//
//  Date+Ext.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 30/05/26.
//

import Foundation

extension Date {
    
    func convertToMonthDateYearTimeFormat() -> String {
        let dateFormatter          = DateFormatter()
        dateFormatter.dateFormat   = "MMM d, yyyy, HH:mm"
        
        return dateFormatter.string(from: self)
    }
}
