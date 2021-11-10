//
//  View.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import Foundation

protocol View: PresenterViewObject {
    
    var presenter: ViewDelegate { get set }
    
    init(presenter: ViewDelegate)
    
}
