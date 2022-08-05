//
//  ViewController.swift
//  InputFieldView
//
//  Created by Frank on 08/05/2022.
//  Copyright (c) 2022 Frank. All rights reserved.
//

import UIKit
import InputFieldView

class ViewController: UIViewController {
    @IBOutlet var fieldView: InputFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        fieldView.resignFirstResponder()
    }
}
