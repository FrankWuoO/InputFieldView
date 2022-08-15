//
//  ViewController.swift
//  InputFieldView
//
//  Created by Frank on 08/05/2022.
//  Copyright (c) 2022 Frank. All rights reserved.
//

import InputFieldView
import UIKit

class ViewController: UIViewController {
    @IBOutlet var listScrollView: UIScrollView!
    @IBOutlet var topRightButton: UIBarButtonItem!

    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var backgroundColorButton: UIButton!
    @IBOutlet var strokeValueLabel: UILabel!
    @IBOutlet var strokeStepper: UIStepper!
    @IBOutlet var linesSegmentedControl: UISegmentedControl!

    @IBOutlet var placeholderTextField: UITextField!
    @IBOutlet var labelTextField: UITextField!
    @IBOutlet var helperTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let navigationVC = segue.destination as? UINavigationController, let viewController = navigationVC.topViewController as? DemoViewController else { return }
        viewController.appearance = prepareAppearance()
    }

    // MARK: - Notification

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrameValue: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)

        additionalSafeAreaInsets.bottom = intersection.size.height
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        additionalSafeAreaInsets.bottom = 0
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }

    func prepareAppearance() -> InputFieldView.Appearance {
        var stateColors: [InputFieldView.State: UIColor] = [:]
        colorButtons.forEach({
            switch $0.tag {
            case 0:
                stateColors[.normal] = $0.backgroundColor!
            case 1:
                stateColors[.focus] = $0.backgroundColor!
            case 2:
                stateColors[.error("")] = $0.backgroundColor!
            default: break
            }
        })

        let allowMultipleLines = linesSegmentedControl.selectedSegmentIndex != 0
        return InputFieldView.Appearance(stateColors: stateColors,
                                         backgroundColor: backgroundColorButton.backgroundColor!,
                                         strokeWidth: strokeStepper.value,
                                         allowMultipleLines: allowMultipleLines,
                                         placeholder: placeholderTextField.text,
                                         labelText: labelTextField.text,
                                         helperText: helperTextField.text)
    }

    @IBAction func triggleTapGesture(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func clickColorButton(_ sender: UIButton) {
        guard #available(iOS 14.0, *) else { return }
        let picker = UIColorPickerViewController()
        picker.view.tag = sender.tag
        picker.selectedColor = sender.backgroundColor!
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    @IBAction func changeStrokeStepper(_ sender: UIStepper) {
        strokeValueLabel.text = "\(sender.value)"
    }
}

@available(iOS 14.0, *)
extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let tag = viewController.view.tag
        if let button = colorButtons.first(where: { $0.tag == tag }) {
            button.backgroundColor = viewController.selectedColor
        }
        else {
            backgroundColorButton.backgroundColor = viewController.selectedColor
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
