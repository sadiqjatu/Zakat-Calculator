//
//  RenderableHistoryItem.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 01/06/26.
//

import Foundation
import CoreData

struct RenderableHistoryItem: Hashable, Sendable {
    
    let id: NSManagedObjectID
    let categoryString: String
    let iconString: String
    let timestamp: Date
    let totalAssets: Double
    let zakatDue: Double
    let currencyCode: String
    
    var iconType: IconType {
        switch iconString.lowercased() {
        case "cash":
            return .cash
        case "gold":
            return .gold
        case "business":
            return .business
        default:
            return .cash
        }
    }
}
