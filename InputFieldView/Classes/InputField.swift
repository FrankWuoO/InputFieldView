//
//  InputField.swift
//  InputFieldView
//
//  Created by cheng-en wu on 2022/8/5.
//

import UIKit

protocol InputFieldDelegate: AnyObject {
    func inputFieldDidBeginEditing(_ inputField: InputField)

    func inputFieldDidEndEditing(_ inputField: InputField)
    
    func inputFieldDidChangeText(_ inputField: InputField)
}

class InputField: UIView {
    
    static let textColor: UIColor = UIColor(hex: 0x252729)
    static let placeholderColor: UIColor = UIColor(hex: 0xA7A7A9)
    static let textFont: UIFont = UIFont.systemFont(ofSize: 15)

    let allowMultipleLines: Bool
    var placeholder: String? = nil
    
    var inputComponent: UIView!
    var text: String {
        switch inputComponent {
        case let component as UITextView:
            return component.text!
        case let component as UITextField:
            return component.text ?? ""
        default: return ""
        }
    }
    
    var placeholderLabel: UILabel?
    
    weak var delegate: InputFieldDelegate?

    init(allowMultipleLines: Bool, placeholder: String? = nil) {
        self.allowMultipleLines = allowMultipleLines
        self.placeholder = placeholder
        super.init(frame: .zero)
        initVariable()
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        allowMultipleLines = false
        placeholder = nil
        super.init(coder: coder)
        initVariable()
        initLayout()
    }
    
    public override func resignFirstResponder() -> Bool {
        return inputComponent.resignFirstResponder()
    }
    
    //MARK: Init
    
    private func initVariable() {
        
    }
    
    private func initLayout() {
        if allowMultipleLines {
            createTextViewLayout()
        }
        else {
            createTextFieldLayout()
        }
    }
        
    func createTextViewLayout() {
        let textView = UITextView()
        textView.textColor = InputField.textColor
        textView.font = InputField.textFont
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        textView.delegate = self
        
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true

        inputComponent = textView
        
        if let placeholder = placeholder {
            let label = UILabel()
            label.text = placeholder
            label.textColor = InputField.placeholderColor
            label.font = textView.font
            
            textView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(greaterThanOrEqualTo: textView.trailingAnchor, constant: 0).isActive = true
            label.topAnchor.constraint(equalTo: textView.topAnchor, constant: 5).isActive = true
            label.bottomAnchor.constraint(greaterThanOrEqualTo: textView.bottomAnchor, constant: 0).isActive = true
            placeholderLabel = label
        }
        
    }
    
    func createTextFieldLayout() {
        let textField = UITextField()
        if let placeholder = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                                 attributes: [.foregroundColor: InputField.placeholderColor])
        }
        textField.textColor = InputField.textColor
        textField.font = InputField.textFont
        textField.returnKeyType = .default
        textField.delegate = self
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        inputComponent = textField
    }
    
    // MARK: Setter
    
    func setCursorColor(_ color: UIColor?) {
        switch inputComponent {
        case let component as UITextView:
            component.tintColor = color
        case let component as UITextField:
            component.tintColor = color
        default: break
        }
    }
    
}

// MARK: - Delegate

extension InputField: UITextViewDelegate {
    // MARK: UITextViewDelegate
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.inputFieldDidBeginEditing(self)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.inputFieldDidEndEditing(self)
    }

    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !textView.text.isEmpty
        delegate?.inputFieldDidChangeText(self)
    }
}

extension InputField: UITextFieldDelegate {
    // MARK: UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.inputFieldDidBeginEditing(self)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.inputFieldDidEndEditing(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

