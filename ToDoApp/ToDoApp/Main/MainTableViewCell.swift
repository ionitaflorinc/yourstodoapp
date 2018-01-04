//
//  MainTableViewCell.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/4/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

let kButtonsWidth: CGFloat = 68 * 3

struct MainTableViewCellItem {
    var text: String?
    var date: Date?
    
    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
}

protocol MainTableViewCellDelegate: class {
    func cellDidReceiveTapOnEditButton(_ cell: MainTableViewCell, button: UIButton)
    func cellDidReceiveTapOnDoneButton(_ cell: MainTableViewCell, button: UIButton)
    func cellDidReceiveTapOnDeleteButton(_ cell: MainTableViewCell, button: UIButton)

}

class MainTableViewCell: UITableViewCell {

    weak open var delegate: MainTableViewCellDelegate?
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var viewContainerLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    fileprivate var startGestureX: CGFloat = 0.0
    fileprivate var lastGestureX: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupGestures()
    }
    
    public func setupWith(text: String, date: String) {
        self.textView.text = text
        self.dateLabel.text = date
    }
    
    fileprivate func setupGestures() {
//        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(didRecognizePanGesture(_:)))
//        self.viewContainer.addGestureRecognizer(panGesture)

        let leftSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(didRecognizeSwipeGesture(_:)))
        leftSwipeGesture.direction = .left
        
        let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(didRecognizeSwipeGesture(_:)))
        rightSwipeGesture.direction = .right
        self.viewContainer.addGestureRecognizer(leftSwipeGesture)
        self.viewContainer.addGestureRecognizer(rightSwipeGesture)
    }

    @objc fileprivate func didRecognizeSwipeGesture(_ swipeGesture: UISwipeGestureRecognizer) {
        self.layoutIfNeeded()

        if swipeGesture.direction == .left {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewContainerLeadingConstraint.constant = -kButtonsWidth
                self.layoutIfNeeded()
            })
        } else if swipeGesture.direction == .right {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewContainerLeadingConstraint.constant = 0
                self.layoutIfNeeded()
            })
        }
    }
    
    @objc fileprivate func didRecognizePanGesture(_ panGesture: UIPanGestureRecognizer) {
        self.layoutIfNeeded()
        if panGesture.state == .began {
            startGestureX = panGesture.translation(in: self.viewContainer).x
        } else if panGesture.state == .changed {
            let currentX = panGesture.translation(in: self.viewContainer).x
            let constantValue = startGestureX - currentX
            
            if constantValue > 0 {
                self.viewContainerLeadingConstraint.constant = -constantValue
            }
            
            lastGestureX = currentX
        } else if panGesture.state == .ended {
            if startGestureX - lastGestureX > 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.viewContainerLeadingConstraint.constant = -kButtonsWidth
                    self.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.viewContainerLeadingConstraint.constant = 0
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func didTapEditbutton(_ sender: UIButton) {
        self.viewContainerLeadingConstraint.constant = 0
        self.delegate?.cellDidReceiveTapOnEditButton(self, button: sender)
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        self.delegate?.cellDidReceiveTapOnDeleteButton(self, button: sender)
    }
    
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        self.delegate?.cellDidReceiveTapOnDoneButton(self, button: sender)
    }
    
}
