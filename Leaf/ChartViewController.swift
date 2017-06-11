//
//  ChartViewController.swift
//  Leaf
//
//  Created by 李源 on 04/06/2017.
//  Copyright © 2017 李源. All rights reserved.
//

import UIKit
import SwiftChart
import Charts

class ChartViewController: UIViewController, ChartDelegate {

    @IBOutlet weak var lineChart: Chart!
    @IBOutlet weak var pieChart: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //这里是swiftchart部分
        lineChart.delegate = self 
        
        let data: [Float] = [12, 18, 21, 25, 30, 28, 22, 20]
        
        let series = ChartSeries(data)
        series.area = true
        
        lineChart.add(series)
        
        // Set minimum and maximum values for y-axis
        lineChart.minY = 40
        lineChart.maxY = 0
        
        // Format y-axis, e.g. with units
        lineChart.yLabelsFormatter = { String(Int($1)) +  "ºC" }
        
        var labels: [Float] = []
        var labelsAsString: Array<String> = []
        
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "EE"
        for i in 0 ..< 7 {
            let temp:String = dataFormatter.weekdaySymbols[i]
            let weeksAsString = (temp as NSString).substring(to: 3)
            labelsAsString.append(weeksAsString)
            labels.append(Float(i))
        }
        print(labelsAsString)
        lineChart.xLabels = labels
        lineChart.xLabelsFormatter = { (labelIndex: Int, labelValue: Float) -> String in
            return labelsAsString[labelIndex]
        }
        lineChart.xLabelsTextAlignment = .center
        
        //这里是chart
        let label = [""]
        let unitsSold = [100.0]
        
        setChart(dataPoints: label, values: unitsSold);
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //这里是swiftchart的按钮相关
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
                //动态改变下面圆状的数据
                let score = value / 50
                let label = ["", "指数"]
                let unitsSold = [Double((50-value)/50), Double(score)]
                
                setChart(dataPoints: label, values: unitsSold)
                
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    //这里是chart的设置
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "百分比")
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
        
    }


}
