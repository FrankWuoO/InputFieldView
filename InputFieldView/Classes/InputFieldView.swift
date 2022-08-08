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
                                                             backgroundColor: UIColor.white,
                                                             strokeWidth: 0.5,
                                                             allowMultipleLines: true,
                                                             placeholder: nil,
                                                             labelText: "Title")

        public var stateColors: [State: UIColor]
        public var backgroundColor: UIColor
        public var strokeWidth: CGFloat
        public var allowMultipleLines: Bool
        
        public var placeholder: String?
        public var labelText: String?
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
                                          placeholder: appearance.placeholder, backgroundColor: appearance.backgroundColor)
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
    
    private(set) var titleLabel: UILabel?
    
    private(set) var inputField: InputField
    
    public init(appearance: Appearance, placeholder: String?) {
        self.appearance = appearance
        inputField = InputField(allowMultipleLines: appearance.allowMultipleLines, placeholder: appearance.placeholder, backgroundColor: appearance.backgroundColor)
        super.init(frame: .zero)
        
        initVariable()
        initLayout()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        appearance = .default
        inputField = InputField(allowMultipleLines: appearance.allowMultipleLines, placeholder: appearance.placeholder, backgroundColor: appearance.backgroundColor)
        super.init(coder: coder)
        
        initVariable()
        initLayout()
        updateAppearance()
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
    }
    
    func createTitleLabel() {
        guard titleLabel == nil else { return }
        let _container = UIStackView()
        _container.spacing = 4
        _container.axis = .vertical
        
        let label = UILabel()
        label.textColor = UIColor(hex: 0x252729)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        _container.addArrangedSubview(label)
        _container.addArrangedSubview(UIView())
        container.insertArrangedSubview(_container, at: 0)
        
        titleLabel = label
    }
    
    // MARK: UI
    
    func updateAppearance() {
        if let text = appearance.labelText {
            createTitleLabel()
            titleLabel?.text = text
            titleLabel?.isHidden = false
        }
        else {
            titleLabel?.text = nil
            titleLabel?.isHidden = true
        }
        
        container.addArrangedSubview(inputField)
        container.addArrangedSubview(separateView)
        
        inputField.setPlaceholder(appearance.placeholder)
        separateView.heightAnchor.constraint(equalToConstant: appearance.strokeWidth).isActive = true
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
