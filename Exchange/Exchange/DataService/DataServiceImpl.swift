//
//  DataServiceImpl.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 04.11.2021.
//

import UIKit

class DataServiceImpl: DataService {
    
    // MARK: - Constants
    
    static private let storedDataPath = "LocalStoragePath"
    static private let initialNumberOfCents = 10_000
    
    // MARK: - Stored Data
    
    struct StoredData: Codable {
        
        var numberOfCents: [Currency: Int]
        var course: CurrencyCourse
        
    }
    
    // MARK: - Elements
    
    private var storedData: StoredData = StoredData(numberOfCents: [:], course: CurrencyCourse())
    
    // MARK: - Initialization
    
    required init() {
        
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActiveNotificationHandler), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    @objc private func willResignActiveNotificationHandler() {
        
        saveData()
        
    }
    
    // MARK: - Load & Save Data
    
    private func loadData() {
        
        if let storedData = getDataFromLocalStorage() {
            self.storedData = storedData
        } else {
            self.storedData = getDefaultStoredData()
        }
        
    }
    
    private func getDataFromLocalStorage() -> StoredData? {
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Self.storedDataPath)
        guard let data = try? Data.init(contentsOf: url) else { return nil }
        guard let storedData = try? JSONDecoder().decode(StoredData.self, from: data) else { return nil }
        return storedData
        
    }
    
    private func getDefaultStoredData() -> StoredData {
        
        let numberOfCents: [Currency: Int] = Currency.all.reduce([:], { partialResult, currency in
            
            var partialResult = partialResult
            partialResult[currency] = Self.initialNumberOfCents
            return partialResult
            
        })
        return StoredData(numberOfCents: numberOfCents, course: CurrencyCourse())
        
    }
    
    private func saveData() {
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(Self.storedDataPath)
        guard let data = try? JSONEncoder().encode(storedData) else { return }
        try? data.write(to: url)
        
    }
    
}

extension DataServiceImpl: InteractorDataServiceObject {
    
    func getNumberOfCents(forCurrency currency: Currency) -> Int {
        
        return storedData.numberOfCents[currency] ?? 0
        
    }
    
    func updateNumberOfCents(numberOfCents: Int, forCurrency currency: Currency) {
        
        storedData.numberOfCents[currency] = numberOfCents
        
    }
    
    func idsoGetCurrencyCourse() -> CurrencyCourse {
        
        return storedData.course
        
    }
    
    func idsoRequestUpdatedCourse(handler: ((_ currencyCourse: CurrencyCourse?) -> Void)?) {
        
        struct WebServerResponse: Codable {
            
            var success: Bool
            var rates: [String: Double]
            
        }
        
        let key = "1fed5a5dcac510c9cf5c5c1745b86530" // You should create a new key and change in the case of exceeded limit
        let currenciesParameter = Currency.all.map({ $0.title }).joined(separator: ",")
        guard let url = URL(string: "http://api.exchangeratesapi.io/v1/latest?access_key=\(key)&symbols=\(currenciesParameter)") else { handler?(nil); return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let data = data else { handler?(nil); return }
                guard error == nil else { handler?(nil); return }
                guard let webServerResponse = try? JSONDecoder().decode(WebServerResponse.self, from: data) else { handler?(nil); return }
                
                let currencyValues: [Currency: Double] = {
                    var currencyValues: [Currency: Double] = [:]
                    webServerResponse.rates.forEach { (currencyName, value) in
                        if let currency = Currency(rawValue: currencyName) {
                            currencyValues[currency] = 1 / value
                        }
                    }
                    return currencyValues
                }()
                
                let course = CurrencyCourse(currencyValues: currencyValues)
                self?.storedData.course = course
                handler?(course)
                
            }
            
        }.resume()
        
    }
    
}
