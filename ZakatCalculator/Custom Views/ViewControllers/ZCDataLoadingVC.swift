//
//  ZCDataLoadingVC.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 03/06/26.
//

import UIKit

class ZCDataLoadingVC: UIViewController {
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView   = ZCEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
