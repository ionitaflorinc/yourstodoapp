//
//  TDOAddTaskButton.swift
//  YourToDoPlan
//
//  Created by Florin Ionita on 11/10/17.
//  Copyright © 2017 TDO. All rights reserved.
//

import UIKit

class TDOAddTaskButton: UIView {

    @IBOutlet weak var addTaskButton: UIButton!
    public var addTaskButtonPressedHandler: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
        
        self.addTaskButton.layer.cornerRadius = self.addTaskButton.frame.size.width / 2
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        if let handler = self.addTaskButtonPressedHandler {
            handler()
        }
    }
}
