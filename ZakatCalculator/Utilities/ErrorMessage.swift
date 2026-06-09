//
//  ErrorMessage.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 26/05/26.
//

import Foundation

enum ZCError: String, Error {
    
    case invalidURL         = "The url is invalid, Please try again."
    case unableToComplete   = "Unable to complete your request, Please check your internet connection."
    case invalidResponse    = "Invalid response from the server, Please try again."
    case invalidData        = "The data received from the server was invalid, Please try again."
}
