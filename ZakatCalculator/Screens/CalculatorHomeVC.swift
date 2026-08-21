//
//  CalculatorHomeVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 17/05/26.
//

import UIKit

class CalculatorHomeVC: UIViewController {

    let tableView = UITableView()
    var calulatorOptions: [CalculatorOption] = [
        .init(title: "wealthSavings".localized, iconType: .cash),
        .init(title: "goldSilver".localized, iconType: .gold),
        .init(title: "businessAssets".localized, iconType: .business)
    ]
    var nisabThreshold: Double = 0
    var goldPrice: Double      = 0
    var silverPrice: Double    = 0
    
    let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    var currentCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        fetchMetalRates()
        configureTableView()
        configureNotificationObserver()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    
    func configureViewController() {
        view.backgroundColor          = Colors.green
    }
    
    
    func fetchMetalRates() {
        NetworkManager.shared.getMetalRates { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let metalData):
                    let currentCurrency = UserDefaults.standard.string(forKey: "selectedCurrency")
                    let currentCurrencyValue = metalData.data.currencyRates[currentCurrency ?? "USD"] ?? 1.0
                    
                    let calculateNisab       = 612.36 * metalData.data.metalPrices.XAG.price * currentCurrencyValue
                    self.nisabThreshold      = calculateNisab
                    
                    self.goldPrice           = metalData.data.metalPrices.XAU.price * currentCurrencyValue
                    self.silverPrice         = metalData.data.metalPrices.XAG.price * currentCurrencyValue
                    
                case .failure(let error):
                    print("Failed to fetch rates: \(error)")
                }
            }
        }
    }
    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance                      = UINavigationBarAppearance()
        appearance.titleTextAttributes      = [ .foregroundColor: UIColor.label ]
        appearance.largeTitleTextAttributes = [ .foregroundColor: UIColor.label ]

        navigationController?.navigationBar.standardAppearance   = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.rowHeight  = 120
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle  = .none
        
        tableView.register(CalculatorCardCell.self, forCellReuseIdentifier: CalculatorCardCell.reuseID)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    func configureNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCurrencyChange),
            name: LocalizationManager.currencyChangedNotification,
            object: nil
        )
    }
    
    
    @objc func handleCurrencyChange() {
        print("Caught the notification signal.")
        fetchMetalRates()
        currentCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "USD"
    }
}


extension CalculatorHomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calulatorOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: CalculatorCardCell.reuseID, for: indexPath) as! CalculatorCardCell
        let option = calulatorOptions[indexPath.row]
        cell.set(title: option.title, iconType: option.iconType)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexRow = indexPath.row
        switch indexRow {
        case 0:
            let wsCalculator             = WSCalculator()
            wsCalculator.title           = "wealthSavings".localized
            wsCalculator.nisabThreshold  = self.nisabThreshold
            wsCalculator.currentCurrency = self.currentCurrency
            navigationController?.pushViewController(wsCalculator, animated: true)
            
        case 1:
            let gsCalculator             = GSCalculator()
            gsCalculator.title           = "goldSilver".localized
            gsCalculator.nisabThreshold  = self.nisabThreshold
            gsCalculator.silverPrice     = self.silverPrice
            gsCalculator.goldPrice       = self.goldPrice
            gsCalculator.currentCurrency = self.currentCurrency
            navigationController?.pushViewController(gsCalculator, animated: true)
            
        case 2:
            let baCalculator             = BACalculator()
            baCalculator.title           = "businessAssets".localized
            baCalculator.nisabThreshold  = self.nisabThreshold
            baCalculator.currentCurrency = self.currentCurrency
            navigationController?.pushViewController(baCalculator, animated: true)
        default:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
