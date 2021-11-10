//
//  PresenterImpl.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import Foundation

class PresenterImpl: Presenter {
    
    // MARK: - Elements
    
    weak var view: PresenterViewObject!
    var interactor: PresenterDelegate
    
    private var activeCurrencyIndexForType: [VDCurrencyType: Int] = [.from: 0, .to: 0]
    private var numberOfCentsToSellForCurrencyIndex: [Int: Int] = [:]
    
    // MARK: - Initialization
    
    required init(interactor: PresenterDelegate) {
        
        self.interactor = interactor
        
    }
    
}

extension PresenterImpl: InteractorPresentationObject {
    
    func ipoCourseUpdated() {
        
        view.pvoReloadCurrencies(currencyType: nil, withUpdatingTextField: false)
        
    }
    
}

extension PresenterImpl: ViewDelegate {
    
    func vdRequestNumberOfCurrencies(currencyType: VDCurrencyType) -> Int {
        
        let numberOfCurrencies = interactor.pdRequestNumberOfCurrencies()
        guard numberOfCurrencies > 0 else { fatalError("Error: number of currencies, returned from interactor, must be positive") }
        return numberOfCurrencies
        
    }
    
    func vdRequestCurrencyData(currencyType: VDCurrencyType, currencyIndex: Int) -> VDCurrencyData {
        
        let currencyData = interactor.pdRequestCurrencyData(currencyIndex: currencyIndex)
        let (numberOfCentsForExchange, course): (Int, String) = {
            if currencyType == .from {
                
                let numberOfCentsForExchange = numberOfCentsToSellForCurrencyIndex[currencyIndex] ?? 0
                let numberOfCentsToBuyFor100SoldCents = interactor.pdRequestExchangeResultNumberOfCents(fromCurrencyIndex: currencyIndex, toCurrencyIndex: activeCurrencyIndexForType[.to]!, fromCurrencyNumberOfCents: 100)
                let toCurrencySymbol = interactor.pdRequestCurrencyData(currencyIndex: activeCurrencyIndexForType[.to]!).symbol
                
                return (numberOfCentsForExchange, prepareCourse(fromCurrencySymbol: currencyData.symbol, toCurrencySymbol: toCurrencySymbol, toCurrencyNumberOfCents: numberOfCentsToBuyFor100SoldCents))
                
            } else {
                
                // currencyType == .to
                let numberOfCentsToSell = numberOfCentsToSellForCurrencyIndex[activeCurrencyIndexForType[.from]!] ?? 0
                let numberOfCentsForExchange = interactor.pdRequestExchangeResultNumberOfCents(fromCurrencyIndex: activeCurrencyIndexForType[.from]!, toCurrencyIndex: currencyIndex, fromCurrencyNumberOfCents: numberOfCentsToSell)
                let numberOfCentsToBuyFor100SoldCents = interactor.pdRequestExchangeResultNumberOfCents(fromCurrencyIndex: activeCurrencyIndexForType[.from]!, toCurrencyIndex: currencyIndex, fromCurrencyNumberOfCents: 100)
                let fromCurrencySymbol = interactor.pdRequestCurrencyData(currencyIndex: activeCurrencyIndexForType[.from]!).symbol
                
                return (numberOfCentsForExchange, prepareCourse(fromCurrencySymbol: fromCurrencySymbol, toCurrencySymbol: currencyData.symbol, toCurrencyNumberOfCents: numberOfCentsToBuyFor100SoldCents))
                
            }
        }()
        
        return VDCurrencyData(
            title: currencyData.title,
            count: "You have: \(prepareNumberOfCents(currencyData.numberOfCents))\(currencyData.symbol)",
            sumForExchange: prepareNumberOfCents(numberOfCentsForExchange),
            course: course)
        
    }
    
    private func prepareCourse(fromCurrencySymbol: String, toCurrencySymbol: String, toCurrencyNumberOfCents: Int) -> String {
        
        return "\(fromCurrencySymbol)\(prepareNumberOfCents(100)) = \(toCurrencySymbol)\(prepareNumberOfCents(toCurrencyNumberOfCents))"
        
    }
    
    private func prepareNumberOfCents(_ numberOfCents: Int) -> String {
        
        return "\(numberOfCents / 100),\((numberOfCents % 100) / 10)\(numberOfCents % 10)"
        
    }
    
    func vdActiveCurrencyChanged(currencyType: VDCurrencyType, currencyIndex: Int) {
        
        activeCurrencyIndexForType[currencyType] = currencyIndex
        view.pvoReloadCurrencies(currencyType: currencyType == .from ? .to : .from, withUpdatingTextField: currencyType == .from)
        
    }
    
    func vdSumForExchangeChanged(sumForExchange: String, editingIsFinished: Bool) {
        
        let currencyIndex = activeCurrencyIndexForType[.from]!
        let numberOfCents: Int? = {
            guard let numberOfCoins = Double(sumForExchange.replacingOccurrences(of: ",", with: ".")) else { return nil }
            guard numberOfCoins >= 0 else { return nil }
            return Int(numberOfCoins * 100)
        }()
        numberOfCentsToSellForCurrencyIndex[currencyIndex] = numberOfCents ?? 0
        view.pvoReloadCurrencies(currencyType: editingIsFinished ? nil : .to, withUpdatingTextField: true)
        
    }
    
    func vdExchangeButtonTapped() {
        
        let fromCurrencyIndex = activeCurrencyIndexForType[.from]!
        let toCurrencyIndex = activeCurrencyIndexForType[.to]!
        interactor.pdRequestPerformExchange(fromCurrencyIndex: fromCurrencyIndex, toCurrencyIndex: toCurrencyIndex, fromCurrencyNumberOfCents: numberOfCentsToSellForCurrencyIndex[fromCurrencyIndex] ?? 0) { [weak self] success in
            
            if success {
                
                self?.numberOfCentsToSellForCurrencyIndex[fromCurrencyIndex] = 0
                self?.view.pvoReloadCurrencies(currencyType: nil, withUpdatingTextField: true)
                
            } else {
                
                self?.view.pvoNotifyAboutLackOfCurrency()
                
            }
            
        }
        
    }
    
}
