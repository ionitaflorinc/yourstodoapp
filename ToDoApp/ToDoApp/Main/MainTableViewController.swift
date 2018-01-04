//
//  MainTableViewController.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/4/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, MainTableViewCellDelegate, CreateTaskViewControllerDelegate {

    let delegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dataSourceLoadedNotification),
                                               name: Utils.kDataSourceLoadedNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Utils.kDataSourceLoadedNotification, object: nil)
    }
    
    fileprivate func getTaskViewController() -> CreateTaskViewController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let taskViewController = storyBoard.instantiateViewController(withIdentifier: "CreateTaskViewControllerIndetifier") as! CreateTaskViewController
        
        return taskViewController
    }
    
    @objc fileprivate func dataSourceLoadedNotification() {
        self.tableView.reloadData()
        ActivityIndicatorManager.show(false)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if let customCell = cell as? MainTableViewCell {
            let item = delegate.dataSource[indexPath.row]
            let date = Utils.stringFromDate(item.date!)
            customCell.setupWith(text: item.text!, date:date)
            customCell.delegate = self
        }
        
        return cell
    }
    
    @IBAction func didTapRightBarButton(_ sender: Any) {
        let taskViewController = self.getTaskViewController()
        
        taskViewController.isEditingController = false
        taskViewController.delegate = self
        self.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    func cellDidReceiveTapOnEditButton(_ cell: MainTableViewCell, button: UIButton) {
        let taskViewController = self.getTaskViewController()
        
        let indexPath = self.tableView.indexPath(for: cell)!
        let item = delegate.dataSource[indexPath.row]
        
        taskViewController.text = item.text
        taskViewController.date = item.date
        taskViewController.indexOfEditedItem = indexPath.row
        taskViewController.isEditingController = true
        taskViewController.delegate = self
        self.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    func cellDidReceiveTapOnDoneButton(_ cell: MainTableViewCell, button: UIButton) {
        let indexPath = self.tableView.indexPath(for: cell)!
        delegate.newDoneTasks.append(delegate.dataSource[indexPath.row])
        delegate.dataSource.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func cellDidReceiveTapOnDeleteButton(_ cell: MainTableViewCell, button: UIButton) {
        let indexPath = self.tableView.indexPath(for: cell)!
        delegate.dataSource.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func taskViewController(_ viewController: CreateTaskViewController, selectedString: String, selectedDate: Date) {
        let item = MainTableViewCellItem.init(text: selectedString, date: selectedDate)
        
        if viewController.isEditingController! {
            delegate.dataSource[viewController.indexOfEditedItem!] = item
        } else {
            delegate.dataSource.append(item)
        }
        self.tableView.reloadData()
    }

}
