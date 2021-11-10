//
//  VTextField.swift
//  Exchange
//
//  Created by Nikita Tsyganov on 11.10.2021.
//  Copyright (c) 2021 Nikita Tsyganov. All rights reserved.
//

import UIKit

protocol VTextFieldDelegate: AnyObject {
    
    func textFieldWillBeginEditing(_: VTextField)
    
}


/**
 A text field subclass. It doesn't become a first responder by click by default. To make it by click, you need to set "isEnabledByClick" property to true.  Also you can make it a first responder by explicitly calling "becomeFirstResponder()" method. Use "text" property to set or get the displayed text. Extra delegate method "textFieldWillBeginEditing(_: TextField)" is called after notification "keyboardWillShowNotification" is posted.

     // Initialization
     init()
 
     // Mutable Properties
     var extraDelegate: TextFieldDelegate?
     var isEnabledByClick: Bool 
 
     // Functions
     override func becomeFirstResponder() -> Bool
     override func resignFirstResponder() -> Bool
 
*/

class VTextField: UITextField, UIGestureRecognizerDelegate {
  
    // MARK: - Elements
    
    weak var extraDelegate: VTextFieldDelegate?
    
    var isEnabledByClick: Bool = false {
        didSet {
            if isEnabledByClick != oldValue {
                if isEnabledByClick {
                    isUserInteractionEnabled = true
                } else if isFirstResponder == false {
                    isUserInteractionEnabled = false
                }
            }
        }
    }
  
    // MARK: - Init
  
    init() {
        super.init(frame: .zero)
        setup()
    }
  
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Become & Resign First Responder
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result {
            isUserInteractionEnabled = true
            extraDelegate?.textFieldWillBeginEditing(self)
        }
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result && isEnabledByClick == false {
            isUserInteractionEnabled = false
        }
        return result
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
  
    // MARK: - Setup
  
    private func setup() {
        isUserInteractionEnabled = isEnabledByClick
    }
    
}
