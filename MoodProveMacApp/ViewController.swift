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
        
        let entry1 = BarChartDataEntry(x: 1.0, y: 2.0)
        let entry2 = BarChartDataEntry(x: 4.0, y: 1.0)
        let entry3 = BarChartDataEntry(x: 5.0, y: 5.0)
        
        let dataSet = BarChartDataSet(values: [entry1, entry2, entry3], label: "")
        let data = BarChartData(dataSets: [dataSet])
        moodDataChart.data = data
    
        moodDataChart.highlightPerTapEnabled = true
        moodDataChart.drawGridBackgroundEnabled = false
        moodDataChart.xAxis.drawGridLinesEnabled = false
        moodDataChart.leftAxis.drawGridLinesEnabled = false
        
        
        // Disabling zoom
        moodDataChart.pinchZoomEnabled = false
        moodDataChart.dragEnabled = false
        moodDataChart.setScaleEnabled(false)
        
        //moodDataChart.animate(xAxisDuration: 5000, yAxisDuration: 5000)
        moodDataChart.backgroundColor = NSColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        moodDataChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        moodDataChart.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
   func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
    }


}

