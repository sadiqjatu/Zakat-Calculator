//
//  MetalAPIResponse.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 26/05/26.
//

import Foundation

struct MetalAPIResponse: Codable  {
    let data: MetalDataPayload
}

struct MetalDataPayload: Codable {
    let metalPrices: MetalPrices
    let currencyRates: [String: Double]
}

struct MetalPrices: Codable {
    let XAU: MetalPriceMetrics
    let XAG: MetalPriceMetrics
}

//struct CurrencyRates: Codable {
//    let USD: Int
//    let EUR: Double
//    let GBP: Double
//    let SAR: Double
//    let AED: Double
//    let PKR: Double
//    let INR: Double
//}

struct MetalPriceMetrics: Codable {
    let price: Double
}
