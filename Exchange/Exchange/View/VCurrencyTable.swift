//
//  VCurrencyTable.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 25.10.2021.
//

import UIKit

/**
 The VCurrencyTable delegate
 
     // Internal Change Notifications (View -> Delegate)
     func vCurrencyTableRequestNumberOfCurrencies(currencyType: VDCurrencyType) -> Int
     func vCurrencyTableRequestCurrencyData(currencyType: VDCurrencyType, currencyIndex: Int) -> VDCurrencyData
     func vCurrencyTableActiveCurrencyChanged(currencyType: VDCurrencyType, currencyIndex: Int)
     func vCurrencyTableSumForExchangeChanged(currencyType: VDCurrencyType, sumForExchange: String, editingIsFinished: Bool)
 
*/

protocol VCurrencyTableDelegate: AnyObject {
    
    // Internal Change Notifications (View -> Delegate)
    func vCurrencyTableRequestNumberOfCurrencies(currencyType: VDCurrencyType) -> Int
    func vCurrencyTableRequestCurrencyData(currencyType: VDCurrencyType, currencyIndex: Int) -> VDCurrencyData
    func vCurrencyTableActiveCurrencyChanged(currencyType: VDCurrencyType, currencyIndex: Int)
    func vCurrencyTableSumForExchangeChanged(currencyType: VDCurrencyType, sumForExchange: String, editingIsFinished: Bool)

}

/**
 The VCurrencyTable. Size: free.
 
     // Initialization
     init(currencyType: VDCurrencyType, delegate: VCurrencyTableDelegate?)
 
     // Functions
     func reload()
 
 */

class VCurrencyTable: UICollectionView {
    
    // MARK: - Constants
    
    // Other Constants
    static private let itemReuseIdentifier = "item_id"
    
    // MARK: - Delegate
    
    weak private var vCurrencyTableDelegate: VCurrencyTableDelegate?
    
    // MARK: - Model Properties
    
    private var currencyType: VDCurrencyType
    private var currentIndexPath: IndexPath?
    
    // MARK: - Init
    
    init(currencyType: VDCurrencyType, delegate: VCurrencyTableDelegate?) {
        
        self.currencyType = currencyType
        self.vCurrencyTableDelegate = delegate
        
        let layout = Self.createLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    static private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = CGFloat(0)
        layout.scrollDirection = .horizontal
        return layout
        
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        self.delegate = self
        self.dataSource = self
        
        // Setup Views
        setupViews()
        
        // Setup Constraints
        setupConstraints()
        
    }
    
    private func setupViews() {
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        register(VCurrencyBlockCell.self, forCellWithReuseIdentifier: Self.itemReuseIdentifier)
        
    }
    
    private func setupConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    // MARK: - Updates
    
    func reload(withUpdatingTextField: Bool) {
        
        let numberOfCurrencies = vCurrencyTableDelegate?.vCurrencyTableRequestNumberOfCurrencies(currencyType: currencyType) ?? 0
        (0..<numberOfCurrencies).forEach { currencyIndex in
            let indexPath = IndexPath(item: currencyIndex, section: 0)
            guard let cell = cellForItem(at: indexPath) as? VCurrencyBlockCell else { return }
            guard let currencyData = vCurrencyTableDelegate?.vCurrencyTableRequestCurrencyData(currencyType: currencyType, currencyIndex: indexPath.item) else { return }
            cell.block.update(currencyData: currencyData, withUpdatingTextField: withUpdatingTextField)
        }
        
    }
    
}

// MARK: - Extensions (UICollection View Data Source)

extension VCurrencyTable: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return vCurrencyTableDelegate?.vCurrencyTableRequestNumberOfCurrencies(currencyType: currencyType) ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.itemReuseIdentifier, for: indexPath) as? VCurrencyBlockCell else { return UICollectionViewCell() }
        guard let currencyData = vCurrencyTableDelegate?.vCurrencyTableRequestCurrencyData(currencyType: currencyType, currencyIndex: indexPath.item) else { return UICollectionViewCell() }
        
        cell.block.updateDelegate(self)
        cell.block.update(currencyData: currencyData, withUpdatingTextField: true)
        cell.block.isEditable = (currencyType == .from)
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let window = window else { return }
        guard let currentCell = visibleCells.first(where: { window.bounds.contains(convert($0.center, to: nil)) }) else { return }
        guard let currentIndexPath = indexPath(for: currentCell) else { return }
        
        if currentIndexPath != self.currentIndexPath {
            self.currentIndexPath = currentIndexPath
            vCurrencyTableDelegate?.vCurrencyTableActiveCurrencyChanged(currencyType: currencyType, currencyIndex: currentIndexPath.item)
        }
        visibleCells.forEach({ $0.endEditing(true) })
        
    }
    
}

// MARK: - Extension (UICollection View Delegate Flow Layout)

extension VCurrencyTable: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: bounds.width, height: bounds.height)
        
    }
    
}

// MARK: - ListOfGamesItemViewDelegate

extension VCurrencyTable: VCurrencyBlockDelegate {
    
    func vCurrencyBlockChanged(newTitle: String, editingIsFinished: Bool) {
        
        vCurrencyTableDelegate?.vCurrencyTableSumForExchangeChanged(currencyType: currencyType, sumForExchange: newTitle, editingIsFinished: editingIsFinished)
        
    }
    
}
