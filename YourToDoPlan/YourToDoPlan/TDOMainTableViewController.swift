//
//  TDOMainTableViewController.swift
//  YourToDoPlan
//
//  Created by Florin Ionita on 11/10/17.
//  Copyright © 2017 TDO. All rights reserved.
//

import UIKit
import MessageUI

let kTDODatasource = "kTDODatasource"

class TDOMainTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Properties
    
    fileprivate var addTaskButton: TDOAddTaskButton!
    fileprivate var dataSource: [String]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupDataSource()
        self.view.layoutIfNeeded()
        self.setupChartsView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupAddTaskButton()
        UIApplication.shared.windows.last?.addSubview(self.addTaskButton);
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let textView: UITextView = UITextView()
        
        let height = UIScreen.main.bounds.height / 6
        
        textView.frame = CGRect.init(x: 0, y: 0, width: cell.frame.width, height: height)
        textView.text = self.dataSource[indexPath.row]
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isUserInteractionEnabled = false
        
        cell.addSubview(textView)
        
        let sendButton: TDOActionButton = TDOActionButton.init(frame: CGRect.init(x: cell.frame.width * 0.8, y: height * 0.7, width: 70, height: 30), title : "Send")
        sendButton.buttonTapped = {
            self.sendEmail(text: textView.text)
        }
        
        cell.addSubview(sendButton)
        
        let removeButton: TDOActionButton = TDOActionButton.init(frame: CGRect.init(x: 20.0, y: height * 0.7, width: 70, height: 30), title: "Remove")
        removeButton.buttonTapped = {
            self.dataSource.remove(at: indexPath.row)
            UserDefaults.standard.setValue(self.dataSource, forKey: kTDODatasource)
            tableView.reloadData()
        }
        
        cell.addSubview(removeButton)
        
        cell.layer.addBorder(edge: .bottom, color: UIColor.lightGray, thickness: 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.displayTaskWindow(text: self.dataSource[indexPath.row], index: NSNumber.init(value: indexPath.row), pickerViewHidden: true)
    }
    
    // MARK: - Private
    
    fileprivate func setupDataSource() {
        if let dataSource = UserDefaults.standard.object(forKey: kTDODatasource) {
            self.dataSource = dataSource as! [String]
        } else {
            self.dataSource = [
                "First task for today \nTuesday",
                "Second task for today \nTuesday",
                "First task for tomorrow \nWednesday",
            ]
        }
    }
    
    fileprivate func setupChartsView() {
        let frame = CGRect.init(x: 0, y: self.view.frame.height - self.view.frame.height / 3, width: self.view.frame.width, height: self.view.frame.height / 3)
        let view = BasicBarChart.init(frame: frame)
        
        view.backgroundColor = .white
        view.layer.addBorder(edge: .top, color: .lightGray, thickness: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath.init(rect: view.bounds).cgPath
        view.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.8
        
        view.dataEntries = [BarEntry(color: .blue, height: 0.75, textValue: "", title: "Today"),
                            BarEntry(color: .green, height: 0.25, textValue: "", title: "Tomorrow")
        ]
        
        UIApplication.shared.windows.last?.addSubview(view);
    }
    
    fileprivate func setupAddTaskButton() {
        self.addTaskButton = Bundle.main.loadNibNamed("TDOAddTaskButton", owner: self, options: nil)?.first as! TDOAddTaskButton
        self.addTaskButton.frame = CGRect.init(x: UIScreen.main.bounds.size.width / 3 * 2.4,
                                               y: UIScreen.main.bounds.size.height / 3 * 2.6,
                                               width: 50,
                                               height: 50)
        
        self.addTaskButton.addTaskButtonPressedHandler = {
            self.displayTaskWindow(text: "", index: nil, pickerViewHidden: false)
        }
    }
    
    fileprivate func sendEmail(text: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody(text, isHTML: true)
            
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    fileprivate func displayTaskWindow(text: String, index: NSNumber?, pickerViewHidden: Bool) {
        let taskViewController = TDOTaskViewController()
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        
        taskViewController.text = text
        taskViewController.shouldBePickerViewHidden = pickerViewHidden
        taskViewController.buttonCompletion = {
            if let index = index {
                self.dataSource[index.intValue] = taskViewController.text!
            } else {
                self.dataSource.append(taskViewController.text!)
            }
            
            window.isHidden = true
            window.removeFromSuperview()
            
            if let tableView = self.tableView {
                tableView.reloadData()
            }
        }
        
        window.rootViewController = taskViewController
        window.makeKeyAndVisible()
    }
    
    // MARK: - MFMailCompose delegate methods
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
