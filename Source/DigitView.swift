//
//  DigitView.swift
//  DigitView
//
//  Created by Øyvind Hauge on 19/02/2021.
//

import UIKit

public protocol DigitViewDelegate: class {
    func didFinishInput(_ input: String)
}

// MARK: - Digit View Configuration (colors, fonts etc.)

public struct DigitViewConfig {
    
    private static let defaultNoOfDigits = 4
    
    private static let defaultBGColor = UIColor(red: 238/255, green: 248/255, blue: 245/255, alpha: 1)
    
    private static let defaultFGColor = UIColor.black
    
    private static let defaultBorderWidth: Float = 1
    
    /// Default config
    public static let `default` = DigitViewConfig(
        noOfDigits: defaultNoOfDigits,
        bgColor: defaultBGColor,
        textColor: defaultFGColor,
        borderColor: defaultFGColor,
        borderWidth: defaultBorderWidth
    )
    
    /// How many text fields to show in the digit view
    public var noOfDigits: Int
    
    /// The background color of the text fields
    public var fieldBackgroundColor: UIColor
    
    /// The text color of the text fields
    public var fieldForegroundColor: UIColor
    
    /// The border color of the text fields (when selected)
    public var fieldBorderColor: UIColor
    
    /// The border width of the text fields
    public var fieldBorderWidth: Float
    
    /// The corner radius of the text fields
    public var fieldCornerRadius: Float = 4
    
    /// If the characters in the text fields should be hidden or nah
    public var isSecure: Bool = true
    
    /// Determines if the selected input fields border should pulsate or not
    public var shouldPulsate: Bool = true
    
    /// The font inf the text fields
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 16)
    

    public init(noOfDigits: Int, bgColor: UIColor, textColor: UIColor,
                borderColor: UIColor, borderWidth: Float) {
        self.noOfDigits = noOfDigits
        self.fieldBackgroundColor = bgColor
        self.fieldForegroundColor = textColor
        self.fieldBorderColor = borderColor
        self.fieldBorderWidth = borderWidth
    }
}

// MARK: - Digit View

public final class DigitView: UIView, DeleteTextDelegate {
    
    public weak var delegate: DigitViewDelegate?
    public var text: String {
        return fields.reduce("") { $0 + $1.text! }
    }
    private let config: DigitViewConfig
    private var fields: [InputField] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    public init(with config: DigitViewConfig = DigitViewConfig.default, delegate: DigitViewDelegate? = nil) {
        self.config = config
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupChildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func becomeFirstResponder() -> Bool {
        guard let firstInputField = fields.first else {
            return true
        }
        return firstInputField.becomeFirstResponder()
    }
    
    private func setupChildViews() {
        addSubview(stackView)
        
        for number in 0..<config.noOfDigits {
            let field = InputField(
                number: number,
                backgroundColor: config.fieldBackgroundColor,
                textColor: config.fieldForegroundColor,
                selectedBorderColor: config.fieldBorderColor,
                deselectedBorderColor: config.fieldBackgroundColor,
                borderWidth: config.fieldBorderWidth,
                cornerRadius: config.fieldCornerRadius,
                isSecure: config.isSecure,
                font: config.font,
                delegate: self,
                deleteDelegate: self
            )
            fields.append(field)
            stackView.addArrangedSubview(field)
        }
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Delete Text Delegate Conformance
    
    fileprivate func didDeleteText(_ inputField: InputField) {
        let prevIndex = inputField.tag - 1
        if cycleInputFields(index: prevIndex) {
            fields[prevIndex].text = ""
        }
    }
}

// MARK: - Text Field Delegate ++

extension DigitView: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // first check that the input character is either numeric or an empty string (the only two valid cases)
        guard isValidInput(string) else {
            return false
        }
        textField.text = string
        let currIndex = textField.tag
        if !string.isEmpty {
            _ = cycleInputFields(index: currIndex + 1)
        }
        // call the public delegate method only when all input fields have been filled
        if allFieldsFilled() {
            delegate?.didFinishInput(text)
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as? InputField)?.toggleBorder(on: true, animated: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? InputField)?.toggleBorder(on: false, animated: true)
    }
    
    private func isValidInput(_ input: String?) -> Bool {
        guard let input = input else { return false }
        let numbers = CharacterSet.decimalDigits
        return CharacterSet(charactersIn: input).isSubset(of: numbers)
    }
    
    private func cycleInputFields(index: Int) -> Bool {
        if index > -1 && index < fields.count {
            fields[index].becomeFirstResponder()
            return true
        }
        endEditing(true)
        return false
    }
    
    private func allFieldsFilled() -> Bool {
        return text.count == config.noOfDigits
    }
}

// MARK: - DeleteTextDelegate is used for handling backspace on the keyboard

fileprivate protocol DeleteTextDelegate: class {
    func didDeleteText(_ inputField: InputField) -> Void
}

// MARK: - InputField is a private UITextField subclass

fileprivate final class InputField: UITextField {
    
    weak var deleteTextDelegate: DeleteTextDelegate?
    
    private let deselectedBorderColor: CGColor
    private let selectedBorderColor: CGColor
    
    init(number: Int, backgroundColor: UIColor, textColor: UIColor, selectedBorderColor: UIColor,
         deselectedBorderColor: UIColor, borderWidth: Float, cornerRadius: Float = 0,
         isSecure: Bool = true, font: UIFont? = nil, delegate: UITextFieldDelegate?, deleteDelegate: DeleteTextDelegate?) {
        self.deselectedBorderColor = deselectedBorderColor.cgColor
        self.selectedBorderColor = selectedBorderColor.cgColor
        self.deleteTextDelegate = deleteDelegate
        super.init(frame: .zero)
        self.delegate = delegate
        self.tag = number
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        isSecureTextEntry = isSecure
        textAlignment = .center
        autocapitalizationType = .none
        keyboardType = .numberPad
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.borderColor = deselectedBorderColor.cgColor
        layer.borderWidth = CGFloat(borderWidth)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        // hide the caret in the text field for a cleaner look
        return .zero
    }
    
    override func deleteBackward() {
        deleteTextDelegate?.didDeleteText(self)
        super.deleteBackward()
    }
    
    func toggleBorder(on: Bool, animated: Bool = true) {
        let newBorderColor = on ? self.selectedBorderColor : self.deselectedBorderColor
        guard animated else {
            layer.borderColor = newBorderColor
            return
        }
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.layer.borderColor = newBorderColor
        }
    }
}
