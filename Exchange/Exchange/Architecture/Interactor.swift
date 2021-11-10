//
//  Interactor.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import Foundation

protocol InteractorPresentationObject: AnyObject {
    
    func ipoCourseUpdated()
    
}

protocol PresenterDelegate: AnyObject {
    
    func pdRequestNumberOfCurrencies() -> Int
    func pdRequestCurrencyData(currencyIndex: Int) -> PDCurrencyData
    func pdRequestExchangeResultNumberOfCents(fromCurrencyIndex: Int, toCurrencyIndex: Int, fromCurrencyNumberOfCents: Int) -> Int
    func pdRequestPerformExchange(fromCurrencyIndex: Int, toCurrencyIndex: Int, fromCurrencyNumberOfCents: Int, handler: ((_ success: Bool) -> Void)?)
    
}

protocol InteractorDataServiceObject: AnyObject {
    
    func getNumberOfCents(forCurrency: Currency) -> Int
    func updateNumberOfCents(numberOfCents: Int, forCurrency: Currency)
    func idsoGetCurrencyCourse() -> CurrencyCourse
    func idsoRequestUpdatedCourse(handler: ((_ currencyCourse: CurrencyCourse?) -> Void)?)
    
}

protocol Interactor: PresenterDelegate {
    
    var presenter: InteractorPresentationObject! { get set }
    var dataService: DataService { get set }
    
    init(dataService: DataService)
    
}

struct PDCurrencyData {
    
    var title: String
    var symbol: String
    var numberOfCents: Int
    
}
