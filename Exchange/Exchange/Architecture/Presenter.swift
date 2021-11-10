//
//  Presenter.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import Foundation

protocol PresenterViewObject: AnyObject {
    
    func pvoReloadCurrencies(currencyType: VDCurrencyType?, withUpdatingTextField: Bool)
    func pvoNotifyAboutLackOfCurrency()
    
}

protocol ViewDelegate: AnyObject {
    
    func vdRequestNumberOfCurrencies(currencyType: VDCurrencyType) -> Int
    func vdRequestCurrencyData(currencyType: VDCurrencyType, currencyIndex: Int) -> VDCurrencyData
    
    func vdActiveCurrencyChanged(currencyType: VDCurrencyType, currencyIndex: Int)
    func vdSumForExchangeChanged(sumForExchange: String, editingIsFinished: Bool)
    func vdExchangeButtonTapped()
    
}

protocol Presenter: InteractorPresentationObject, ViewDelegate {
    
    var view: PresenterViewObject! { get set }
    var interactor: PresenterDelegate { get set }
    
    init(interactor: PresenterDelegate)
    
}

enum VDCurrencyType {
    
    case from, to
    
}

struct VDCurrencyData {
    
    var title: String
    var count: String
    var sumForExchange: String
    var course: String
    
}
