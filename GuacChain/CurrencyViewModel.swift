//
//  CurrencyViewModel.swift
//  GuacChain
//
//  Created by Philip Keller on 2/27/23.
//

import Foundation

@MainActor
class CurrencyViewModel: ObservableObject {
    
    struct Result: Codable {
        var bpi: BPI
    }
    
    struct BPI: Codable {
        var USD: USD
        var GBP: GBP
        var EUR: EUR
    }
    
    struct USD: Codable {
        var rate_float: Double
    }
    
    struct GBP: Codable {
        var rate_float: Double
    }
    
    struct EUR: Codable {
        var rate_float: Double
    }
    
    @Published var usdPerBTC = 0.0
    @Published var gbpPerBTC = 0.0
    @Published var eurPerBTC = 0.0
    
    var urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
    
    func getData() async {
        print("🕸️We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create url from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON from \(urlString)")
                return
            }
            usdPerBTC = result.bpi.USD.rate_float
            gbpPerBTC = result.bpi.GBP.rate_float
            eurPerBTC = result.bpi.EUR.rate_float
            print("One bitcoin is currently worth : $\(usdPerBTC), £\(gbpPerBTC), €\(eurPerBTC)")
            
        } catch {
            print("😡 ERROR: Could not use URL at \(urlString) to get data & response.")
        }
    }
}
