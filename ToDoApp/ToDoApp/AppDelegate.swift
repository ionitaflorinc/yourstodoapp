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
    var powerUser: Bool!
    
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
            
            self.databaseRef.child("user_profiles").child(user!.uid).child("data_source").observeSingleEvent(of: .value, with: { (snapshot) in
                if (snapshot.value as? NSDictionary) != nil {
                    self.dataSource = self.dataSourceForSnapshot(snapshot)
                    
                    NotificationCenter.default.post(name: Utils.kDataSourceLoadedNotification, object: nil)
                } else {
                    ActivityIndicatorManager.show(false)
                }
            })
            
            self.databaseRef.child("user_profiles").child(user!.uid).child("done_tasks").observeSingleEvent(of: .value, with: { (snapshot) in
                if (snapshot.value as? NSDictionary) != nil {
                    self.doneTasks = self.dataSourceForSnapshot(snapshot)
                }
            })
            
            self.databaseRef.child("user_profiles").child(user!.uid).child("power_user").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapValue = snapshot.value {
                    self.powerUser = snapValue as! Bool
                } else {
                    self.powerUser = false
                }
            })
            
            self.window?.rootViewController?.childViewControllers.first?.performSegue(withIdentifier: "MainLogicIdentifier", sender: nil)
        }
    }
    
    func dataSourceForSnapshot(_ snapshot: DataSnapshot) -> [MainTableViewCellItem] {
        var dataSourceItems: [MainTableViewCellItem] = []
        
        if let tasks = snapshot.value as? NSDictionary {
            for item in tasks {
                let taskDictionary = item.value as? NSDictionary
                let text = taskDictionary!["text"] as! String
                let date = taskDictionary!["date"] as! String
                
                let taskItem = MainTableViewCellItem.init(text: text, date: Utils.dateFromString(date))
                dataSourceItems.append(taskItem)
            }
        }
        
        return dataSourceItems
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

struct Utils {
    static let kDataSourceLoadedNotification = NSNotification.Name.init("kDataSourceLoadedNotification")
    
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

