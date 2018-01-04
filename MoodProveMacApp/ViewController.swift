//
//  ViewController.swift
//  MoodProveMacApp
//
//  Created by Malik Graham on 12/28/17.
//  Copyright © 2017 Malik Graham. All rights reserved.
//

import Cocoa
import Charts

class ViewController: NSViewController, ChartViewDelegate {
    
    @IBOutlet weak var moodDataChart: BarChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Getting the current date to create a
        let date = Date()
        retrieveBarChartData(currentDate: date.timeIntervalSinceNow)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }
    
    func setUpBarChart(retreivedDataEntries: [ChartDataEntry], earlistTimeInRetrievedEntries: TimeInterval) {
        
        // Set up Date Formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "EEEE (MM/dd/yyyy)"
        formatter.locale = Locale.current
        
        // Set up xValuesFormatter for the chart
        let xValuesNumberFormatter = ChartXAxisValueFormatter(referenceTimeInterval: earlistTimeInRetrievedEntries, dateFormatter: formatter)
        
        let xAxis = moodDataChart.xAxis
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        xAxis.valueFormatter = xValuesNumberFormatter
        
        
        let barChartDataSet = BarChartDataSet(values: retreivedDataEntries, label: nil)
        barChartDataSet.colors = [NSUIColor.magenta]
        let data = BarChartData(dataSets: [barChartDataSet])
        moodDataChart.data = data
        
        
        moodDataChart.highlightPerTapEnabled = true
        moodDataChart.drawGridBackgroundEnabled = false
        // moodDataChart.xAxis.drawGridLinesEnabled = false
        // moodDataChart.leftAxis.drawGridLinesEnabled = false
        // moodDataChart.leftAxis.gridColor = NSUIColor.blue
        // Disabling zoom
        moodDataChart.pinchZoomEnabled = false
        moodDataChart.dragEnabled = false
        moodDataChart.setScaleEnabled(false)
        
        let limitLines: [Double] = [1, 2, 3]
        for k:Int in 0 ..< limitLines.count {
            let limitLine = ChartLimitLine()
            limitLine.lineColor = NSUIColor.red
            limitLine.limit = limitLines[k]
            limitLine.lineWidth = 2.0
            moodDataChart.leftAxis.addLimitLine(limitLine)
            
        }
        
        //moodDataChart.animate(xAxisDuration: 5000, yAxisDuration: 5000)
        moodDataChart.backgroundColor = NSColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        moodDataChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        moodDataChart.delegate = self
    }
    
    func retrieveBarChartData(currentDate: Double) {
        var dataEntries: [ChartDataEntry] = []
        
        
        // Mock Data
        let date_1: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        let date_2: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        let date_3: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let date_4: Date = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        
        let num_data_1: TimeInterval = date_1.timeIntervalSince1970
        let num_data_2: TimeInterval = date_2.timeIntervalSince1970
        let num_data_3: TimeInterval = date_3.timeIntervalSince1970
        let num_data_4: TimeInterval = date_4.timeIntervalSince1970
    
        
        dataEntries.append(BarChartDataEntry(x: (num_data_4 - num_data_4) / (3600 * 24), y: 2.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_3 - num_data_4) / (3600 * 24), y: 3.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_2 - num_data_4) / (3600 * 24), y: 2.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_1 - num_data_4) / (3600 * 24), y: 1.0))
        
        setUpBarChart(retreivedDataEntries: dataEntries, earlistTimeInRetrievedEntries: num_data_4)
    }

    

}


