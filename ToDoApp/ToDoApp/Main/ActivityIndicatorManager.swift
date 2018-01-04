//
//  ActivityIndicatorManager.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/4/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

class ActivityIndicatorManager: NSObject {

    private static var window: UIWindow?
    
    public static func displayActivityWindow() {
        let activityViewController = ActivityIndicatorViewController()
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = activityViewController
        self.window?.makeKeyAndVisible()
    }
    
    public static func hideActivityWindow() {
        self.window?.isHidden = true
        self.window?.removeFromSuperview()
    }
    
    public static func show(_ display: Bool?) {
        if (display)! {
            self.displayActivityWindow()
        } else {
            self.hideActivityWindow()
        }
    }
    
}
