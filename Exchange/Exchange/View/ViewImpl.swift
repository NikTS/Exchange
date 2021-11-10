//
//  ViewImpl.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 23.10.2021.
//

import UIKit

class ViewImpl: UIViewController, View {
    
    // MARK: - Constants
    
    // Layout Constants
    static private let horizontalOffset = CGFloat(0)
    static private let verticalOffsetBetweenTopBarAndFromTypeCurrencyTable = CGFloat(10)
    static private let currencyTableHeight = CGFloat(100)
    
    // Style Constants
    static private let backgroundColor = UIColor.white
    static private let arrowLabelFontSize = CGFloat(48)
    static private let arrowLabelTitle = "⬇︎"
    
    // MARK: - Elements
    
    var presenter: ViewDelegate
    
    // MARK: - Views
    
    private let topBar = VTopBar()
    lazy private var fromTypeCurrencyTable = VCurrencyTable(currencyType: .from, delegate: self)
    private let arrowLabel = UILabel()
    lazy private var toTypeCurrencyTable = VCurrencyTable(currencyType: .to, delegate: self)
    
    // MARK: - Initialization
    
    required init(presenter: ViewDelegate) {
        
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - VIew Did Load
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        setupViews()
        setupConstraints()
        
        addTapGestureRecognizer()
        
    }
    
    private func setupViews() {
        
        view.backgroundColor = Self.backgroundColor
        
        topBar.updateDelegate(self)
        view.addSubview(topBar)
        
        view.addSubview(fromTypeCurrencyTable)
        
        arrowLabel.font = UIFont(name: VCommonConstants.fontName, size: Self.arrowLabelFontSize)
        arrowLabel.text = Self.arrowLabelTitle
        view.addSubview(arrowLabel)
        
        view.addSubview(toTypeCurrencyTable)
        
    }
    
    // MARK: - Tap Gesture Recognizer
    
    private func addTapGestureRecognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGestureRecognizer)
        
    }

    @objc private func tapGestureHandler(sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            view.endEditing(true)
        }
        
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        
        [view, topBar, fromTypeCurrencyTable, arrowLabel, toTypeCurrencyTable].forEach({ $0?.translatesAutoresizingMaskIntoConstraints = false })
        
        topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        [fromTypeCurrencyTable, toTypeCurrencyTable].forEach({ $0.heightAnchor.constraint(equalToConstant: Self.currencyTableHeight).isActive = true })
        
        fromTypeCurrencyTable.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: Self.verticalOffsetBetweenTopBarAndFromTypeCurrencyTable).isActive = true
        fromTypeCurrencyTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.horizontalOffset).isActive = true
        fromTypeCurrencyTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.horizontalOffset).isActive = true
        
        arrowLabel.topAnchor.constraint(equalTo: fromTypeCurrencyTable.bottomAnchor).isActive = true
        arrowLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        toTypeCurrencyTable.topAnchor.constraint(equalTo: arrowLabel.bottomAnchor).isActive = true
        toTypeCurrencyTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.horizontalOffset).isActive = true
        toTypeCurrencyTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.horizontalOffset).isActive = true
        
    }
    
}

extension ViewImpl: VTopBarDelegate {
    
    func vTopBarButtonTapped() {
        
        view.endEditing(true)
        presenter.vdExchangeButtonTapped()
        
    }
    
}

extension ViewImpl: PresenterViewObject {
    
    func pvoReloadCurrencies(currencyType: VDCurrencyType?, withUpdatingTextField: Bool) {
        
        if currencyType != .to {
            fromTypeCurrencyTable.reload(withUpdatingTextField: withUpdatingTextField)
        }
        if currencyType != .from {
            toTypeCurrencyTable.reload(withUpdatingTextField: withUpdatingTextField)
        }
        
    }
    
    func pvoNotifyAboutLackOfCurrency() {
        
        let alert = UIAlertController(title: "Insufficient funds", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewImpl: VCurrencyTableDelegate {
    
    func vCurrencyTableRequestNumberOfCurrencies(currencyType: VDCurrencyType) -> Int {
        
        presenter.vdRequestNumberOfCurrencies(currencyType: currencyType)
        
    }
    
    func vCurrencyTableRequestCurrencyData(currencyType: VDCurrencyType, currencyIndex: Int) -> VDCurrencyData {
        
        presenter.vdRequestCurrencyData(currencyType: currencyType, currencyIndex: currencyIndex)
        
    }
    
    func vCurrencyTableActiveCurrencyChanged(currencyType: VDCurrencyType, currencyIndex: Int) {
        
        presenter.vdActiveCurrencyChanged(currencyType: currencyType, currencyIndex: currencyIndex)
        
    }
    
    func vCurrencyTableSumForExchangeChanged(currencyType: VDCurrencyType, sumForExchange: String, editingIsFinished: Bool) {
        
        presenter.vdSumForExchangeChanged(sumForExchange: sumForExchange, editingIsFinished: editingIsFinished)
        
    }
    
}
