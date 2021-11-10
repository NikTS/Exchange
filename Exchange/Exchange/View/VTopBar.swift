//
//  VTopBar.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 25.10.2021.
//

import UIKit

/**

 
     // Internal Change Notifications (View -> Delegate)
     func vTopBarButtonTapped()
 
*/

protocol VTopBarDelegate: AnyObject {
    
    // MARK: - Internal Change Notifications (View -> Delegate)
    func vTopBarButtonTapped()

}

/**
 The VTopBar. Size: fixed height.
 
     // Initialization
     init()
 
     // Functions
     func updateDelegate(_ delegate: VTopBarDelegate?)
     func updateTitle(_ title: String)
 
 */

class VTopBar: UIView {
    
    // MARK: - Constants
    
    // Style Constants
    static private let backgroundColor = UIColor(cgColor: .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0))
    static private let buttonTitle = "Exchange"
    
    // MARK: - Delegate
    
    private weak var delegate: VTopBarDelegate?
    
    // MARK: - Views
    
    private let backView = UIView()
    private let navigationBar = UINavigationBar()
    
    // MARK: - Init
    
    init() {
        
        super.init(frame: .zero)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        setupViews()
        setupConstraints()
        
    }
    
    private func setupViews() {
        
        backView.backgroundColor = Self.backgroundColor
        addSubview(backView)
        
        let navigationItem = UINavigationItem(title: "")
        let action = UIAction(handler: { [weak self] _ in
            self?.delegate?.vTopBarButtonTapped()
        })
        let barButton = UIBarButtonItem(title: Self.buttonTitle, image: nil, primaryAction: action, menu: nil)
        navigationItem.setRightBarButton(barButton, animated: false)
        navigationBar.pushItem(navigationItem, animated: false)
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = Self.backgroundColor
        addSubview(navigationBar)
        
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        backView.topAnchor.constraint(equalTo: topAnchor, constant: -50).isActive = true
        backView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        navigationBar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        navigationBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    // MARK: - Updates
    
    func updateDelegate(_ delegate: VTopBarDelegate?) {
        
        self.delegate = delegate
        
    }
    
    func updateTitle(_ title: String) {
        
        navigationBar.topItem?.title = title
        
    }
    
}
