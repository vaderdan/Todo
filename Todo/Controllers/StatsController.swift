//
//  StatsController.swift
//  Todo
//
//  Created by Danny on 23.01.19.
//  Copyright © 2019 Danny Lazarov. All rights reserved.
//

import Foundation
import UIKit
import Charts

class StatsController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var taskStore: TaskStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        let dataPoints = ["Todo", "Done"]
        let values = [taskStore.info().todo.count, taskStore.info().done.count]
        var colors: [UIColor] = [#colorLiteral(red: 0.8784313725, green: 0.4901960784, blue: 0.4823529412, alpha: 1), #colorLiteral(red: 0.231372549, green: 0.7411764706, blue: 0.6509803922, alpha: 1)]
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = ChartDataEntry(x: Double(i), y: Double(values[i]), data: dataPoints[i] as AnyObject)
            
            dataEntries.append(dataEntry1)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Todos completed")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData

        pieChartDataSet.colors = colors
    }
}
