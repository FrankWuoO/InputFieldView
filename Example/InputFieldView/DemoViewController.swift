//
//  DemoViewController.swift
//  InputFieldView_Example
//
//  Created by cheng-en wu on 2022/8/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import InputFieldView
import UIKit

class DemoViewController: UIViewController {
    @IBOutlet var allowEmptyTextView: UIStackView!

    var appearance: InputFieldView.Appearance?
    var checkEmptyText: Bool = true

    var fieldView: InputFieldView?

    override func viewDidLoad() {
        super.viewDidLoad()
        createInputFieldView()
        // Do any additional setup after loading the view.
    }

    func createInputFieldView() {
        guard let appearance = appearance else { return }

        let fieldView = InputFieldView(appearance: appearance)
        fieldView.delegate = self
        view.addSubview(fieldView)
        fieldView.translatesAutoresizingMaskIntoConstraints = false

        fieldView.topAnchor.constraint(equalTo: allowEmptyTextView.bottomAnchor, constant: 16).isActive = true
        fieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        fieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        self.fieldView = fieldView
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @IBAction func switchedAllowEmptyText(_ sender: UISwitch) {
        checkEmptyText = sender.isOn
        view.endEditing(true)
    }

    func checkTextIfNeeded() {
        guard let fieldView = fieldView else { return }
        if checkEmptyText {
            if fieldView.text.isEmpty {
                fieldView.state = .error("Should not be empty")
            }
            else {
                fieldView.state = .normal
            }
        }
        else {
            fieldView.state = .normal
        }
    }

    @IBAction func clickCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension DemoViewController: InputFieldViewDelegate {
    func inputFieldViewDidBeginEditing(_ view: InputFieldView) {}

    func inputFieldViewDidEndEditing(_ view: InputFieldView) {
        checkTextIfNeeded()
    }

    func inputFieldViewDidChangeText(_ view: InputFieldView) {}
}
