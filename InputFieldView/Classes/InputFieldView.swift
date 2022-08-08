//
//  InputFieldView.swift
//  InputFieldView
//
//  Created by cheng-en wu on 2022/8/5.
//

import Foundation

public class InputFieldView: UIView {
    public struct Appearance {
        public static let `default`: Appearance = Appearance(stateColors: [.normal: UIColor(hex: 0xDBDBDB),
                                                                           .focus: UIColor(hex: 0xFF5537),
                                                                           .error(""): UIColor(hex: 0xC03F45)],
                                                             placeholder: nil,
                                                             allowMultipleLines: true)

        public var stateColors: [State: UIColor]
        public var placeholder: String?
        public var allowMultipleLines: Bool
    }

    public enum State: Equatable, Hashable {
        case normal
        case focus
        case error(_ message: String)

        public static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.normal, .normal): return true
            case (.focus, .focus): return true
            case (.error, .error): return true
            default: return false
            }
        }
    }

    lazy var container: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var separateView: UIView = UIView()

    public var appearance: Appearance {
        didSet{
            if oldValue.allowMultipleLines != appearance.allowMultipleLines {
                let newField = InputField(allowMultipleLines: appearance.allowMultipleLines,
                                          placeholder: appearance.placeholder)
                updateInputField(newField)
            }

            updateAppearance()
        }
    }

    public var state: State = .normal {
        didSet {
            let color = appearance.stateColors[state]
            inputField.setCursorColor(color)
            separateView.backgroundColor = color
        }
    }
    
    private(set) var inputField: InputField
    
    public init(appearance: Appearance, placeholder: String?) {
        self.appearance = appearance
        inputField = InputField(allowMultipleLines: appearance.allowMultipleLines, placeholder: appearance.placeholder)
        super.init(frame: .zero)
        
        initVariable()
        initLayout()
    }

    required init?(coder: NSCoder) {
        appearance = .default
        inputField = InputField(allowMultipleLines: appearance.allowMultipleLines, placeholder: appearance.placeholder)
        super.init(coder: coder)
        
        initVariable()
        initLayout()
    }

    public override func resignFirstResponder() -> Bool {
        return inputField.resignFirstResponder()
    }
    
    // MARK: Init

    func initVariable() {
        inputField.delegate = self
        state = .normal
    }

    func initLayout() {
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        container.addArrangedSubview(inputField)
        container.addArrangedSubview(separateView)

        separateView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // MARK: UI
    
    func updateAppearance() {
        inputField.setPlaceholder(appearance.placeholder)
    }
    
    func updateInputField(_ inputField: InputField) {
        if let index = container.subviews.index(of: self.inputField) {
            container.insertArrangedSubview(inputField, at: index)
            self.inputField.removeFromSuperview()
            self.inputField = inputField
            
            inputField.delegate = self
        }
    }

}

// MARK: - Delegate

extension InputFieldView: InputFieldDelegate {
    func inputFieldDidBeginEditing(_ inputField: InputField) {
        print(#function, inputField.inputComponent.classForCoder)
        state = .focus
    }

    func inputFieldDidEndEditing(_ inputField: InputField) {
        print(#function, inputField.inputComponent.classForCoder)
        state = .normal
    }
    
    func inputFieldDidChangeText(_ inputField: InputField) {
        print(#function, inputField.text)
    }
}
