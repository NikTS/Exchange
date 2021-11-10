//
//  BuilderImpl.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import UIKit

class BuilderImpl: Builder {
    
    func buildAndLaunch(window: UIWindow) {
        
        let dataService = DataServiceImpl()
        let interactor = InteractorImpl(dataService: dataService)
        let presenter = PresenterImpl(interactor: interactor)
        let view = ViewImpl(presenter: presenter)
        
        interactor.presenter = presenter
        presenter.view = view
    
        window.rootViewController = view
        window.makeKeyAndVisible()
        
    }
    
}
