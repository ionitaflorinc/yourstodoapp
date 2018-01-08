//
//  ChartsViewController.swift
//  ToDoApp
//
//  Created by Florin Ionita on 1/5/18.
//  Copyright © 2018 mobile. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController {

    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var chartsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = delegate.doneTasks
        let view = BasicBarChart.init(frame: self.chartsView.bounds)
        
        var dataDictionary: Dictionary<Date, Int> = [:]
        for item in dataSource {
            let date = item.date
            if let itemsCompleted =  dataDictionary[date!] {
                dataDictionary[date!] = itemsCompleted + 1
            } else {
                dataDictionary[date!] = 1
            }
        }
        
        var chartDataSource: [BarEntry] = []
        for item in dataDictionary {
            let barEntry = BarEntry(color: .blue, height: Float(item.value) * Float(0.1), textValue:"", title:Utils.stringFromDate(item.key))
            chartDataSource.append(barEntry)
        }
        
        view.dataEntries = chartDataSource
        self.chartsView.addSubview(view)
    }

}
