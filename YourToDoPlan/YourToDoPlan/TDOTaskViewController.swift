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
    
    public var text: String?
    public var buttonCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let text = self.text {
            self.taskTextView.text = text
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
            self.text = self.taskTextView.text
            self.taskTextView.resignFirstResponder()
            completion()
        }
    }
    

}
