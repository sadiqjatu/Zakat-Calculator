//
//  Constants.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 16/05/26.
//

import UIKit

enum SFSymbols {
    
    static let checkmark    = UIImage(systemName: "checkmark.circle.fill")
}


enum Images {
    
    static let zcLogo       = UIImage(named: "calculator")
    static let zcEducation  = UIImage(systemName: "book")
    static let zcHistory    = UIImage(systemName: "clock")
    static let zcSettings   = UIImage(systemName: "gearshape")
}


enum Colors {
    
    static let green        = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
    static let green2       = UIColor(red: 136/255, green: 217/255, blue: 189/255, alpha: 1)
    static let lightGreen   = UIColor(red: 213/255, green: 242/255, blue: 216/255, alpha: 1)
    static let ultraLightGreen = UIColor(red: 236/255, green: 253/255, blue: 245/255, alpha: 1)
    static let darkGreen    = UIColor(red: 2/255, green: 140/255, blue: 16/255, alpha: 1)
    static let ultraDarkGreen = UIColor(red: 2/255, green: 80/255, blue: 60/255, alpha: 1)
    
    static let amber        = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
    static let lightAmber   = UIColor(red: 245/255, green: 238/255, blue: 228/255, alpha: 1)
    static let darkAmber    = UIColor(red: 150/255, green: 97/255, blue: 6/255, alpha: 1)
    
    static let blue         = UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 1)
    static let blue2        = UIColor(red: 75/255, green: 137/255, blue: 255/255, alpha: 1)
    static let lightBlue    = UIColor(red: 189/255, green: 200/255, blue: 244/255, alpha: 1)
    static let darkBlue     = UIColor(red: 6/255, green: 80/255, blue: 201/255, alpha: 1)
    
    static let lightGold    = UIColor(red: 254/255, green: 251/255, blue: 236/255, alpha: 1)
    static let darkGold     = UIColor(red: 125/255, green: 55/255, blue: 11/255, alpha: 1)
    
    static let silver       = UIColor(red: 235/255, green: 239/255, blue: 245/255, alpha: 1)
}


enum Icons {
    
    static let cash             = UIImage(systemName: "wallet.bifold")
    static let gold             = UIImage(named: "gem")
    static let briefcase        = UIImage(systemName: "briefcase")
    static let checkmarkCircle  = UIImage(systemName: "checkmark.arrow.trianglehead.clockwise")
    static let infoCircle       = UIImage(systemName: "info.circle")
    static let refresh          = UIImage(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
    static let chevronDown      = UIImage(systemName: "chevron.down")
    static let chevronRight     = UIImage(systemName: "chevron.right")
    static let chevronLeft      = UIImage(systemName: "chevron.left")
    static let person2          = UIImage(systemName: "person.2")
    static let risingArrow      = UIImage(systemName: "chart.line.uptrend.xyaxis")
    static let gift             = UIImage(systemName: "gift")
    static let trash            = UIImage(systemName: "trash")
    static let page             = UIImage(systemName: "text.page")
    static let checkmark        = UIImage(systemName: "checkmark")
}


enum WSCalculatorStrings {
    
    static let cashAtHome     = "cashAtHome"
    static let bankAccounts   = "bankAccounts"
    static let savings        = "savings"
    static let investments    = "investments"
    static let loanedMoney    = "loanedMoney"
    static let assets         = "assets"
    static let totalWealth    = "totalWealth"
}


enum GSCalculatorStrings {
    
    static let currentPrices    = "currentPrices"
    static let gold             = "gold"
    static let goldAmount       = "goldAmount"
    static let goldPricePerGram = "goldPricePerGram"
    static let goldValue        = "goldValue"
    static let silver           = "silver"
    static let silverAmount     = "silverAmount"
    static let silverPricePerGram = "silverPricePerGram"
    static let silverValue      = "silverValue"
    static let totalValue       = "totalValue"
}


enum BACalculatorStrings {
    
    static let inventoryStock     = "inventoryStock"
    static let cashInBusiness     = "cashInBusiness"
    static let accountsReceivable = "accountsReceivable"
    static let rawMaterials       = "rawMaterials"
    static let finishedGoods      = "finishedGoods"
    static let totalAssets        = "totalAssets"
}


enum ResultVCStrings {
    static let aboveNisabThreshold = "aboveNisabThreshold"
    static let belowNisabThreshold = "belowNisabThreshold"
    static let yourZakatDue        = "yourZakatDue"
    static let recalculate         = "recalculate"
}

enum CommonUIStrings {
    
    static let nisabThreshold = "nisabThreshold"
    static let calculateZakat = "calculateZakat"
    static let reset          = "reset"
    static let nisabTextInfo = "nisabTextInfo"
}

enum EducationVCStrings {
    
    static let learnAboutZakat = "learnAboutZakat"
    static let zakatInfo        = "zakatInfo"
    
    static let questionOne      = "questionOne"
    static let questionTwo      = "questionTwo"
    static let questionThree    = "questionThree"
    static let questionFour     = "questionFour"
    static let questionFive     = "questionFive"
    
    static let answerOne        = "answerOne"
    static let answerTwo        = "answerTwo"
    static let answerThree      = "answerThree"
    static let answerFour       = "answerFour"
    static let answerFive       = "answerFive"
    
    static let subtitleLabel    = "subtitleLabel"
}


enum HistoryVCStrings {
    
    static let noCalculationsYet = "noCalculationsYet"
    static let historyPlaceholder = "historyPlaceholder"
}


enum SettingsVCStrings {
    
    static let language       = "language"
    static let currency       = "currency"
    static let appDescription = "appDescription"
    static let version        = "version"
    static let appNameText    = "appNameText"
}

