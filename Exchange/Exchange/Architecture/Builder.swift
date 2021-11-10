//
//  Builder.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import UIKit

protocol Builder: AnyObject {
    
    func buildAndLaunch(window: UIWindow)
    
}
