//
//  UIHelper.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 08/06/26.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnFlowlayout(width: CGFloat) -> UICollectionViewFlowLayout{
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availaibleWidth             = width - (padding * 2) - (minimumItemSpacing * 2) - (10 * 2)
        let itemWidth                   = availaibleWidth / 3
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth / 2)

        return flowLayout
    }
}
