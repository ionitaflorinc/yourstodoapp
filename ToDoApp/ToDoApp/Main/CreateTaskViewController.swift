//
//  CreateTaskViewController.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/4/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

protocol CreateTaskViewControllerDelegate: class {
    func taskViewController(_ viewController: CreateTaskViewController, selectedString: String, selectedDate: Date)
}

class CreateTaskViewController: UIViewController, UITextFieldDelegate {

    weak open var delegate: CreateTaskViewControllerDelegate?
    
    var text: String?
    var date: Date?
    var isEditingController: Bool?
    var indexOfEditedItem: Int?
    
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDoneButton()
        self.setupTextField()
        
        if let string = self.text {
            self.textField.text = string
        }
        
        if let date = self.date {
            self.datePicker.date = date
        }
        
    }
    
    fileprivate func setupTextField() {
        self.textField.layer.shadowColor = UIColor.black.cgColor
        self.textField.layer.shadowPath = UIBezierPath.init(rect: self.textField.bounds).cgPath
        self.textField.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.textField.layer.shadowRadius = 10
        self.textField.layer.shadowOpacity = 0.8
    }

    fileprivate func setupDoneButton() {
        let rightBarButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc fileprivate func doneButtonTapped(_ button: UIBarButtonItem) {
        if self.textField.isFirstResponder {
            self.textField.resignFirstResponder()
        } else {
            self.delegate?.taskViewController(self, selectedString: self.textField.text, selectedDate: self.datePicker.date)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
