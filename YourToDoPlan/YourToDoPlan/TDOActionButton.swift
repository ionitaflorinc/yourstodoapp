//
//  TDOSendButton.swift
//  YourToDoPlan
//
//  Created by Florin Ionita on 11/10/17.
//  Copyright © 2017 TDO. All rights reserved.
//

import UIKit
import MessageUI

class TDOActionButton: UIButton, MFMailComposeViewControllerDelegate  {
    public var task: String?
    public var buttonTapped: (() -> Void)?
    
    public init(frame: CGRect, title: String) {
        super.init(frame: frame);
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func didTapButton() {
        if let buttonTapped = self.buttonTapped {
            buttonTapped()
        }
    }
}
