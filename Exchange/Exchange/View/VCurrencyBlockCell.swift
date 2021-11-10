//
//  VCurrencyBlockCell.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 25.10.2021.
//

import UIKit

/**
 A VCurrencyBlockCell

     // Initialization
     init()
 
     // Read-Only Properties
     var block VCurrencyBlock
 
*/

class VCurrencyBlockCell: UICollectionViewCell {
    
    // MARK: - View Elements
    
    private(set) var block: VCurrencyBlock
    
    // MARK: - Init
    
    init() {
        
        self.block = VCurrencyBlock()
        super.init(frame: .zero)
        setup()
        
    }
    
    convenience override init(frame: CGRect) {
        
        self.init()
        
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
        
        addSubview(block)
        
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {

        block.topAnchor.constraint(equalTo: topAnchor).isActive = true
        block.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        block.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        block.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}

