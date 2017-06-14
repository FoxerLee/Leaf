//
//  ChartViewController.swift
//  Leaf
//
//  Created by 李源 on 04/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var temPie: PieChartView!
    @IBOutlet weak var humPie: PieChartView!
    @IBOutlet weak var sunPie: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //这里是chart
        let label = ["",""]
        let unitsSold = [80.0, 20.0]
        
        setChart(dataPoints: label, values: unitsSold, pieChart: temPie, flag: 0)
        setChart(dataPoints: label, values: unitsSold, pieChart: humPie, flag: 1)
        setChart(dataPoints: label, values: unitsSold, pieChart: sunPie, flag: 2)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }

    
    //这里是chart的设置
    func setChart(dataPoints: [String], values: [Double], pieChart: PieChartView, flag: Int) {
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.label = ""
        pieChartDataSet.setColor(NSUIColor(red: 136/255, green: 190/255, blue: 187/255, alpha: 1.0))
        
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        
        pieChart.centerText = ""
        let d = Description()
        d.text = ""
        pieChart.chartDescription = d
        pieChart.backgroundColor = UIColor.clear
    }

    
    
}
