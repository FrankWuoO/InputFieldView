//
//  InputFieldView.swift
//  InputFieldView
//
//  Created by cheng-en wu on 2022/8/5.
//

import Foundation

class InputFieldFactory {
    static func make(for appearance: InputFieldView.Appearance) -> InputField {
        return InputField(allowMultipleLines: appearance.allowMultipleLines,
                          placeholder: appearance.placeholder,
                          backgroundColor: appearance.backgroundColor,
                          underLineHeight: appearance.strokeWidth)
    }
}

public protocol InputFieldViewDelegate: AnyObject {
    func inputFieldViewDidBeginEditing(_ view: InputFieldView)

    func inputFieldViewDidEndEditing(_ view: InputFieldView)
    
    func inputFieldViewDidChangeText(_ view: InputFieldView)
}

public class InputFieldView: UIView {
    public struct Appearance {
        
        public static let `default`: Appearance = Appearance(stateColors: [.normal: UIColor(hex: 0xDBDBDB),
                                                                           .focus: UIColor(hex: 0xFF5537),
                                                                           .error(""): UIColor(hex: 0xC03F45)],
                                                             backgroundColor: UIColor.white,
                                                             strokeWidth: 0.5,
                                                             allowMultipleLines: false,
                                                             placeholder: nil,
                                                             labelText: "Title",
                                                             helperText: "This is helper text")

        public var stateColors: [State: UIColor]
        public var backgroundColor: UIColor
        public var strokeWidth: CGFloat
        public var allowMultipleLines: Bool
        
        public var placeholder: String?
        public var labelText: String?
        public var helperText: String?
        
        public init(stateColors: [InputFieldView.State : UIColor], backgroundColor: UIColor, strokeWidth: CGFloat, allowMultipleLines: Bool, placeholder: String? = nil, labelText: String? = nil, helperText: String? = nil) {
            self.stateColors = stateColors
            self.backgroundColor = backgroundColor
            self.strokeWidth = strokeWidth
            self.allowMultipleLines = allowMultipleLines
            self.placeholder = placeholder
            self.labelText = labelText
            self.helperText = helperText
        }
    }

    public enum State: Hashable, Equatable {
        case normal
        case focus
        case error(_ message: String)
    
        public var hashValue: Int{
            switch self {
            case .normal: return 0
            case .focus: return 1
            case .error: return 2
            }
        }
    
        public func hash(into hasher: inout Hasher) {
        }
        
        public static func == (lhs: State, rhs: State) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    lazy var container: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var topSubcontainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        view.addArrangedSubview(UIView())
        return view
    }()
    
    lazy var bottomSubcontainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        view.addArrangedSubview(UIView())
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleNormalColor
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        return label
    }()
    
    private(set) var inputField: InputField
    
    private(set) lazy var helperLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: 0x747476)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        return label
    }()
    
    private(set) lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        return label
    }()
    
    public var appearance: Appearance {
        didSet{
            if oldValue.allowMultipleLines != appearance.allowMultipleLines {
                let newField = InputFieldFactory.make(for: appearance)
                updateInputField(newField)
            }

            updateAppearance()
            let state = self.state
            self.state = state
        }
    }

    public var state: State = .normal {
        didSet {
            let color = appearance.stateColors[state]
            inputField.setCursorColor(color)
            inputField.underLine.backgroundColor = color
            
            switch state {
            case .normal, .focus:
                titleLabel.textColor = UIColor.titleNormalColor
                
                if let text = helperLabel.text, !text.isEmpty {
                    helperLabel.isHidden = false
                }
                else {
                    helperLabel.isHidden = true
                }
                
                errorLabel.text = nil
                errorLabel.isHidden = true
                
            case .error(let message):
                titleLabel.textColor = color

                helperLabel.isHidden = true

                errorLabel.text = message
                errorLabel.isHidden = false
            }
            
            hideBottomSubcontainerIfNeeded()
        }
    }
    
    public var text: String { inputField.text }
    
    public weak var delegate: InputFieldViewDelegate?
    

    public init(appearance: Appearance) {
        self.appearance = appearance
        inputField = InputFieldFactory.make(for: appearance)
        super.init(frame: .zero)
        
        initVariable()
        initLayout()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        appearance = .default
        inputField = InputFieldFactory.make(for: appearance)
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

        container.addArrangedSubview(topSubcontainer)
        container.addArrangedSubview(inputField)
        container.addArrangedSubview(bottomSubcontainer)

        topSubcontainer.insertArrangedSubview(titleLabel, at: 0)
        
        bottomSubcontainer.addArrangedSubview(helperLabel)
        bottomSubcontainer.addArrangedSubview(errorLabel)
    }
    
    // MARK: UI
    
    func hideBottomSubcontainerIfNeeded() {
        bottomSubcontainer.isHidden = helperLabel.isHidden && errorLabel.isHidden
    }
    
    func updateAppearance() {
        titleLabel.text = appearance.labelText
        if let text = titleLabel.text, !text.isEmpty {
            titleLabel.isHidden = false
        }
        else {
            titleLabel.isHidden = true
        }
        
        helperLabel.text = appearance.helperText
        if let text = helperLabel.text, !text.isEmpty {
            helperLabel.isHidden = false
        }
        else {
            helperLabel.isHidden = true
        }
        
        inputField.setPlaceholder(appearance.placeholder)
        inputField.setUnderLineHeight(appearance.strokeWidth)

        errorLabel.textColor = appearance.stateColors[.error("")]

        hideBottomSubcontainerIfNeeded()
    }
    
    func updateInputField(_ inputField: InputField) {
        if let index = container.subviews.firstIndex(of: self.inputField) {
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
        if state == .normal {
            state = .focus
        }
        delegate?.inputFieldViewDidBeginEditing(self)
    }

    func inputFieldDidEndEditing(_ inputField: InputField) {
        if state == .focus {
            state = .normal
        }
        delegate?.inputFieldViewDidEndEditing(self)
    }
    
    func inputFieldDidChangeText(_ inputField: InputField) {
        delegate?.inputFieldViewDidChangeText(self)
    }
}
