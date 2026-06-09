//
//  ZCTabBarController.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 17/05/26.
//

import UIKit

class ZCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)
        
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let direction: UISemanticContentAttribute = (currentLanguage == "ar") ? .forceRightToLeft : .forceLeftToRight
        
        UIView.appearance().semanticContentAttribute          = direction
        UITabBar.appearance().semanticContentAttribute        = direction
        UINavigationBar.appearance().semanticContentAttribute = direction
        
        viewControllers = [createCalculatorHomeNC(), createEducationVC(), createHistoryVC(), createSettingsVC()]
    }
    

    func createCalculatorHomeNC() ->  UINavigationController{
        let calculatorHomeVC    = CalculatorHomeVC()
        calculatorHomeVC.title  = "calculateYourZakat".localized
        
        let nav = UINavigationController(rootViewController: calculatorHomeVC)
        nav.tabBarItem = UITabBarItem(title: "calculator".localized, image: Images.zcLogo, tag: 0)
        
        return nav
    }
    
    
    func createEducationVC() -> UIViewController {
        let educationVC   = EducationVC()
        educationVC.title = EducationVCStrings.learnAboutZakat.localized
        
        let nav = UINavigationController(rootViewController: educationVC)
        nav.tabBarItem = UITabBarItem(title: "education".localized, image: Images.zcEducation, tag: 1)
        
        return nav
    }
    
    func createHistoryVC() -> UIViewController {
        let historyVC   = HistoryVC()
        historyVC.title = "calculationHistory".localized
        
        let nav = UINavigationController(rootViewController: historyVC)
        nav.tabBarItem = UITabBarItem(title: "history".localized, image: Images.zcHistory, tag: 2)
        
        return nav
    }
    
    
    func createSettingsVC() -> UIViewController {
        let settingVC   = SettingsVC()
        settingVC.title = "settings".localized
        
        let nav = UINavigationController(rootViewController: settingVC)
        nav.tabBarItem = UITabBarItem(title: "settings".localized, image: Images.zcSettings, tag: 3)
        
        return nav
    }
}
