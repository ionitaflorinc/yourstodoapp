//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/3/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    var databaseRef: DatabaseReference!
    var user: User!
    var dataSource = [MainTableViewCellItem]()
    var doneTasks = [MainTableViewCellItem]()
    
    var newDoneTasks = [MainTableViewCellItem]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            ActivityIndicatorManager.show(false)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let _ = error {
                ActivityIndicatorManager.show(false)
                return
            }
            
            self.user = user
            
            self.databaseRef = Database.database().reference()
            self.databaseRef.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if (snapshot.value as? NSDictionary) == nil {
                    self.databaseRef.child("user_profiles").child(user!.uid).child("name").setValue(user?.displayName)
                    self.databaseRef.child("user_profiles").child(user!.uid).child("email").setValue(user?.email)
                }
            })
            
            self.databaseRef.child("user_profiles").child(user!.uid).child("done_tasks").observeSingleEvent(of: .value, with: { (snapshot) in
                if let tasks = snapshot.value as? NSArray {
                    for item in tasks {
                        if let task = item as? NSDictionary {
                            let text = task["text"] as! String
                            let date = task["date"] as! String
                            
                            let taskItem = MainTableViewCellItem.init(text: text, date: Utils.dateFromString(date))
                            self.dataSource.append(taskItem)
                        }
                    }
                }
            })
            
            self.window?.rootViewController?.childViewControllers.first?.performSegue(withIdentifier: "MainLogicIdentifier", sender: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        for item in self.newDoneTasks {
            let dateAsString = Utils.stringFromDate(item.date!)
            let newRef = self.databaseRef.child("user_profiles").child(self.user.uid).child("done_tasks").childByAutoId()
            newRef.child("text").setValue(item.text!)
            newRef.child("date").setValue(dateAsString)
        }
        
        self.databaseRef.child("user_profiles").child(self.user.uid).child("data_source").removeValue()
        
        for item in self.dataSource {
            let dateAsString = Utils.stringFromDate(item.date!)
            let newRef = self.databaseRef.child("user_profiles").child(self.user.uid).child("data_source").childByAutoId()
            newRef.child("text").setValue(item.text!)
            newRef.child("date").setValue(dateAsString)
        }
        
    }
    
}

struct Utils {
    static func dateFromString(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let date = dateFormatter.date(from: string)
        
        return date!
    }
    
    static func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}

