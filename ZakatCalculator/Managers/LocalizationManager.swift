//
//  LocalizationManager.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 18/05/26.
//

import Foundation


final class LocalizationManager {
    
    static let shared = LocalizationManager()
    static let currencyChangedNotification = Notification.Name("CurrencyChanged")
    
    private init() {}
    
    var currentLanguage: String {
        UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    }
    
    
    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
                  return key
              }
        
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
