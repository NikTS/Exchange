//
//  CurrencyCourse.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 04.11.2021.
//

import Foundation

struct CurrencyCourse: Codable {
    
    private var currencyValues: [Currency: Double]
    
    init(currencyValues: [Currency: Double]) {
        
        self.currencyValues = currencyValues
        
    }
    
    func getNumberOfCents(initialCurrency: Currency, resultCurrency: Currency, initialNumberOfCents: Int) -> Int {
        
        let initialCurrencyValue = currencyValues[initialCurrency] ?? 1
        let resultCurrencyValue = currencyValues[resultCurrency] ?? 1
        
        return Int((initialCurrencyValue / resultCurrencyValue) * Double(initialNumberOfCents))
        
    }
    
    init() {
        
        self.currencyValues = Currency.all.reduce([:], { partialResult, currency in
            
            var partialResult = partialResult
            partialResult[currency] = 1
            return partialResult
            
        })
        
    }
    
}
