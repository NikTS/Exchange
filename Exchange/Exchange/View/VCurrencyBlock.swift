//
//  VCurrencyBlock.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 25.10.2021.
//

import UIKit

/**
 The VCurrencyBlock delegate

     // Internal Change Notifications (View -> Delegate)
     func vCurrencyBlockChanged(newTitle: String, editingIsFinished: Bool)
 
*/

protocol VCurrencyBlockDelegate: AnyObject {
    
    // MARK: - Internal Change Notifications (View -> Delegate)
    func vCurrencyBlockChanged(newTitle: String, editingIsFinished: Bool)

}

/**
 The VCurrencyBlock. Size: free.
 
     // Initialization
     init()
 
     // Mutable Properties (default: true)
     var isEditable: Bool
 
     // Functions
     func updateDelegate(_ delegate: VCurrencyBlockDelegate?)
     func update(currencyData: VDCurrencyData)
 
 */

class VCurrencyBlock: UIView {
    
    // MARK: - Constants
    
    // Layout Constants
    static private let externalInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    static private let internalInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static private let sumForExchangeTextFieldWidth = CGFloat(200)
    
    // Style Constants
    static private let backgroundColor = UIColor(cgColor: .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0))
    static private let borderColor = UIColor.gray
    static private let cornerRadius = CGFloat(5)
    static private let borderWidth = CGFloat(1)
    static private let titleLabelFontSize = CGFloat(24)
    static private let countLabelFontSize = CGFloat(18)
    static private let sumForExchangeTextFieldFontSize = CGFloat(24)
    static private let courseLabelFontSize = CGFloat(12)
    
    // MARK: - Delegate
    
    private weak var delegate: VCurrencyBlockDelegate?
    
    // MARK: - Model Properties
    
    var isEditable: Bool = true {
        didSet {
            sumForExchangeTextField.isEnabledByClick = isEditable
        }
    }
    
    // MARK: - Views
    
    private let externalContainer = UIView()
    private let internalContainer = UIView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let sumForExchangeTextField = VTextField()
    private let courseLabel = UILabel()
    
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
        
        // Setup Views
        setupViews()
        
        // Setup Constraints
        setupConstraints()
        
    }
    
    private func setupViews() {
        
        externalContainer.backgroundColor = Self.backgroundColor
        externalContainer.layer.cornerRadius = Self.cornerRadius
        externalContainer.layer.borderColor = Self.borderColor.cgColor
        externalContainer.layer.borderWidth = Self.borderWidth
        addSubview(externalContainer)
        
        externalContainer.addSubview(internalContainer)
        
        titleLabel.font = UIFont(name: VCommonConstants.fontName, size: Self.titleLabelFontSize)
        internalContainer.addSubview(titleLabel)
        
        countLabel.font = UIFont(name: VCommonConstants.fontName, size: Self.countLabelFontSize)
        internalContainer.addSubview(countLabel)
        
        sumForExchangeTextField.keyboardType = .decimalPad
        sumForExchangeTextField.font = UIFont(name: VCommonConstants.fontName, size: Self.sumForExchangeTextFieldFontSize)
        sumForExchangeTextField.isEnabledByClick = true
        sumForExchangeTextField.textAlignment = .right
        sumForExchangeTextField.delegate = self
        sumForExchangeTextField.addTarget(self, action: #selector(sumForExchangeTextChangedHandler), for: .editingChanged)
        internalContainer.addSubview(sumForExchangeTextField)
        
        courseLabel.font = UIFont(name: VCommonConstants.fontName, size: Self.courseLabelFontSize)
        internalContainer.addSubview(courseLabel)
        
    }
    
    @objc private func sumForExchangeTextChangedHandler() {
        
        delegate?.vCurrencyBlockChanged(newTitle: sumForExchangeTextField.text ?? "", editingIsFinished: false)
        
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        
        [self, externalContainer, internalContainer, titleLabel, countLabel, sumForExchangeTextField, courseLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        externalContainer.topAnchor.constraint(equalTo: topAnchor, constant: Self.externalInsets.top).isActive = true
        externalContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.externalInsets.left).isActive = true
        externalContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.externalInsets.right).isActive = true
        externalContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.externalInsets.bottom).isActive = true
        
        internalContainer.topAnchor.constraint(equalTo: externalContainer.topAnchor, constant: Self.internalInsets.top).isActive = true
        internalContainer.leadingAnchor.constraint(equalTo: externalContainer.leadingAnchor, constant: Self.internalInsets.left).isActive = true
        internalContainer.trailingAnchor.constraint(equalTo: externalContainer.trailingAnchor, constant: -Self.internalInsets.right).isActive = true
        internalContainer.bottomAnchor.constraint(equalTo: externalContainer.bottomAnchor, constant: -Self.internalInsets.bottom).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: internalContainer.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: internalContainer.leadingAnchor).isActive = true
        
        countLabel.leadingAnchor.constraint(equalTo: internalContainer.leadingAnchor).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: internalContainer.bottomAnchor).isActive = true
        
        sumForExchangeTextField.topAnchor.constraint(equalTo: internalContainer.topAnchor).isActive = true
        sumForExchangeTextField.trailingAnchor.constraint(equalTo: internalContainer.trailingAnchor).isActive = true
        sumForExchangeTextField.widthAnchor.constraint(equalToConstant: Self.sumForExchangeTextFieldWidth).isActive = true
        
        courseLabel.trailingAnchor.constraint(equalTo: internalContainer.trailingAnchor).isActive = true
        courseLabel.bottomAnchor.constraint(equalTo: internalContainer.bottomAnchor).isActive = true
        
    }
    
    // MARK: - Updates
    
    func updateDelegate(_ delegate: VCurrencyBlockDelegate?) {
        
        self.delegate = delegate
        
    }
    
    func update(currencyData: VDCurrencyData, withUpdatingTextField: Bool) {
        
        titleLabel.text = currencyData.title
        countLabel.text = currencyData.count
        if withUpdatingTextField {
            sumForExchangeTextField.text = currencyData.sumForExchange
        }
        courseLabel.text = currencyData.course
        
    }
    
}

extension VCurrencyBlock: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        delegate?.vCurrencyBlockChanged(newTitle: textField.text ?? "", editingIsFinished: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}
