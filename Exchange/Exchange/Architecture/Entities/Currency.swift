//
//  Currency.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 04.11.2021.
//

import Foundation

enum Currency: String, Codable {
    
    case eur = "EUR"
    case usd = "USD"
    case gbp = "GBP"
    case rub = "RUB"
    
    var title: String {
        
        return rawValue
        
    }
    
    var symbol: String {
        
        let symbols: [Currency: String] = [
            .eur: "€",
            .usd: "$",
            .gbp: "£",
            .rub: "₽"
        ]
        
        return symbols[self] ?? ""
        
    }
    
    static var all: [Currency] {
        
        return [.eur, .usd, .gbp, .rub]
        
    }
    
}
