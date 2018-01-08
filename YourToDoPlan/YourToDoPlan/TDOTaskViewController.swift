//
//  TDOTaskViewController.swift
//  YourToDoPlan
//
//  Created by Florin Ionita on 11/10/17.
//  Copyright © 2017 TDO. All rights reserved.
//

import UIKit

class TDOTaskViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerVIew: UIPickerView!
    let pickerViewDataSource = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    public var shouldBePickerViewHidden: Bool?
    public var text: String?
    public var buttonCompletion: (() -> Void)?
    public var lastSelected = "Monday"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let text = self.text {
            self.taskTextView.text = text
        }
        self.containerView.layer.cornerRadius = 15.0
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 2.0
        self.pickerVIew.dataSource = self
        self.pickerVIew.delegate = self
        if (self.shouldBePickerViewHidden!) {
            self.lastSelected = ""
            self.pickerVIew.isHidden = true
        }
        
//        let topBlurView = self.configureBlurView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.containerView.frame.origin.y))
//        
//        let y = self.containerView.frame.origin.y + self.containerView.frame.height
//        let bottomBlurView = self.configureBlurView(frame: CGRect.init(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height - y))
//        
////        self.view.insertSubview(topBlurView, belowSubview: self.taskTextView)
//        self.view.insertSubview(bottomBlurView, belowSubview: self.taskTextView)
    }
    
    fileprivate func configureBlurView(frame: CGRect) -> UIView {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }
    
//    @IBAction func saveTaskButtonTapped(_ sender: Any) {
//        if let completion = self.saveButtonTapped {
//            self.text = taskTextView.text
//            completion()
//        }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if let completion = self.buttonCompletion {
            self.text = self.taskTextView.text + "\n\(self.lastSelected)"
            self.taskTextView.resignFirstResponder()
            completion()
        }
    }
}

extension TDOTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerViewDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lastSelected = self.pickerViewDataSource[row]
    }
}
