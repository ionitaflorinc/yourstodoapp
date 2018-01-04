//
//  ActivityIndicatorViewController.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/4/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        self.configureActivityIndicator()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func configureActivityIndicator() {
        let container: UIView = UIView()
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.init(rgbValue: 0x000000, alpha: 0.7)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor.init(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.center = CGPoint.init(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        actInd.startAnimating()
        
        container.addSubview(loadingView)
        loadingView.addSubview(actInd)
        self.view.addSubview(container)
    }
    
}

extension UIColor {
    convenience init(rgbValue:UInt32, alpha:Double=1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: CGFloat(alpha)
        )
    }
}
