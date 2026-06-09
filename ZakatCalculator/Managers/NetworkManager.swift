//
//  NetworkManager.swift
//  ZakatCalculator
//
//  Created by Sadiq Jatu on 25/05/26.
//

import UIKit

struct SecretKeys: Codable {
    let metalApiKey: String
}

class NetworkManager {
    
    static let shared    = NetworkManager()
    private let baseUrl  = "https://gold.g.apised.com/v1"
    private let cacheKey = "cachedMetalRates"
    private var apiKey   = ""
    
    private init() { }              //Cant create an instance from outside
    
    func getMetalRates(completed: @escaping (Result<MetalAPIResponse, ZCError>) -> Void ){
        
//        Check the cache first
        if let cacheData = UserDefaults.standard.data(forKey: cacheKey),
           let cachedObj = try? JSONDecoder().decode(CachedMetalData.self, from: cacheData) {
            // Check if the date is as same as today
            if Calendar.current.isDateInToday(cachedObj.downloadDate) {
                print("DEBUG: Using fresh local cache. Saved internet call! ")
                completed(.success(cachedObj.response))
                return
            }
        }
        
        //get the api key
        guard let plistURL = Bundle.main.url(forResource: "Secrets", withExtension: "plist") else {
            fatalError("Secrets.plist file not found in the app bundle!")
        }
        
        do {
            let plistData = try Data(contentsOf: plistURL)
            let decoder   = PropertyListDecoder()
            let secrets   = try decoder.decode(SecretKeys.self, from: plistData)
            
            self.apiKey   = secrets.metalApiKey
            print("My hidden api key is: \(self.apiKey)")
        } catch {
            fatalError("Failed to read or decode Secrets.plist: \(error.localizedDescription)")
        }
        
        let endpoint = baseUrl + "/latest?metals=XAU%2CXAG&base_currency=USD&currencies=USD%2CEUR%2CGBP%2CSAR%2CAED%2CPKR%2CINR&weight_unit=gram"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")//place the api key to plist
        request.httpMethod = "GET"
        
        let task    = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let metalRates = try decoder.decode(MetalAPIResponse.self, from: data)
                
                self.saveToCache(response: metalRates)      //saving to local cache
                completed(.success(metalRates))
            } catch{
                print("DEBUG Parsing Error: \(error)")
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    private func saveToCache(response: MetalAPIResponse) {
        let cacheObj = CachedMetalData(response: response, downloadDate: Date())
        if let encoded = try? JSONEncoder().encode(cacheObj) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
            print("DEBUG: Successfully updated the local daily cache.")
        }
    }
}
