//
//  InteractorImpl.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import Foundation

class InteractorImpl: Interactor {
    
    // MARK: - Constants
    
    static private let updateCourseInterval : Double = 30
    
    // MARK: - Elements
    
    weak var presenter: InteractorPresentationObject!
    var dataService: DataService
    
    // MARK: - Initialization
    
    required init(dataService: DataService) {
        
        self.dataService = dataService
        setupTimer()
        
    }
    
    // MARK: - Setup Timer
    
    private func setupTimer() {
        
        func updateCourse() {
            
            dataService.idsoRequestUpdatedCourse { [weak self] currencyCourse in
                
                self?.presenter.ipoCourseUpdated()
                
            }
            
        }
        
        updateCourse()
        
        Timer.scheduledTimer(withTimeInterval: Self.updateCourseInterval, repeats: true) { timer in
            
            updateCourse()
            
        }
        
    }
    
}

extension InteractorImpl: PresenterDelegate {
    
    func pdRequestNumberOfCurrencies() -> Int {
        
        return Currency.all.count
        
    }
    
    func pdRequestCurrencyData(currencyIndex: Int) -> PDCurrencyData {
        
        guard (0..<Currency.all.count).contains(currencyIndex) else { fatalError("Error: presenter requested currency data with incorrect index") }
        
        let currency = Currency.all[currencyIndex]
        let numberOfCents = dataService.getNumberOfCents(forCurrency: currency)
        return PDCurrencyData(title: currency.title, symbol: currency.symbol, numberOfCents: numberOfCents)
        
    }
    
    func pdRequestExchangeResultNumberOfCents(fromCurrencyIndex: Int, toCurrencyIndex: Int, fromCurrencyNumberOfCents: Int) -> Int {
        
        let range = (0..<Currency.all.count)
        guard range.contains(fromCurrencyIndex) && range.contains(toCurrencyIndex) else { fatalError("Error: presenter requested exchange result with incorrect indexes") }
        guard fromCurrencyNumberOfCents >= 0 else { fatalError("Error: presenter requested exchange result with incorrect inumber of cents") }
        
        let course = dataService.idsoGetCurrencyCourse()
        let initialCurrency = Currency.all[fromCurrencyIndex]
        let resultCurrency = Currency.all[toCurrencyIndex]
        return course.getNumberOfCents(initialCurrency: initialCurrency, resultCurrency: resultCurrency, initialNumberOfCents: fromCurrencyNumberOfCents)
        
    }
    
    func pdRequestPerformExchange(fromCurrencyIndex: Int, toCurrencyIndex: Int, fromCurrencyNumberOfCents: Int, handler: ((_ success: Bool) -> Void)?) {
        
        let range = (0..<Currency.all.count)
        guard range.contains(fromCurrencyIndex) && range.contains(toCurrencyIndex) else { fatalError("Error: presenter requested perform exchange with incorrect indexes") }
        
        let fromCurrency = Currency.all[fromCurrencyIndex]
        let toCurrency = Currency.all[toCurrencyIndex]
        let oldFromCurrencyNumberOfCents = dataService.getNumberOfCents(forCurrency: fromCurrency)
        let oldToCurrencyNumberOfCents = dataService.getNumberOfCents(forCurrency: toCurrency)
        guard fromCurrencyNumberOfCents >= 0 else { fatalError("Error: presenter requested perform exchange with incorrect number of cents") }
        guard fromCurrencyNumberOfCents <= dataService.getNumberOfCents(forCurrency: fromCurrency) else { handler?(false); return }
        guard fromCurrencyIndex != toCurrencyIndex else { handler?(true); return }
        
        let course = dataService.idsoGetCurrencyCourse()
        let newFromCurrencyNumberOfCents = oldFromCurrencyNumberOfCents - fromCurrencyNumberOfCents
        let newToCurrencyNumberOfCents = oldToCurrencyNumberOfCents + course.getNumberOfCents(initialCurrency: fromCurrency, resultCurrency: toCurrency, initialNumberOfCents: fromCurrencyNumberOfCents)
        dataService.updateNumberOfCents(numberOfCents: newFromCurrencyNumberOfCents, forCurrency: fromCurrency)
        dataService.updateNumberOfCents(numberOfCents: newToCurrencyNumberOfCents, forCurrency: toCurrency)
        handler?(true)
        
    }
    
}
