//
//  TDOSendButton.swift
//  YourToDoPlan
//
//  Created by Florin Ionita on 11/10/17.
//  Copyright © 2017 TDO. All rights reserved.
//

import UIKit
import MessageUI

class TDOSendButton: UIButton, MFMailComposeViewControllerDelegate  {
    public var task: String?
    public var buttonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.setTitle("Send", for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func sendButtonTapped() {
        if let sendButtonTapped = self.buttonTapped {
            sendButtonTapped()
        }
    }
}
