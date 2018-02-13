//
//  ViewController.swift
//  MoodProveMacApp
//
//  Created by Malik Graham on 12/28/17.
//  Copyright © 2017 Malik Graham. All rights reserved.
//

import Cocoa
import Charts
import OAuthSwift
import SwiftyJSON

class MainViewController: NSViewController, ChartViewDelegate {
    
    var minimumTimestamp: TimeInterval?
    
    var maximumTimestamp: TimeInterval?
    
    var userId: String?
    
    var name: String?
    
    let moodProveServerDomain: String = "http://localhost:8080"
    
    @IBOutlet weak var moodDataChart: BarChartView!
    
    @IBAction func getPastMoodBefore(_ sender: Any) {
        
        // String(describing: Int(minimumTimestamp!.timeIntervalSince1970))
        let userid = "happy"
        let timestamp = 3
        let res = MoodProveHTTP.getRequest(urlRequest: "\(moodProveServerDomain)/mood/beforeOrAfter?userid=\(userid)&timestamp=\(minimumTimestamp!)&type=before")
            self.handleChangeInMoodTime(json: res)
    }

    @IBAction func getPastMoodAfter(_ sender: Any) {
        // String(describing: Int(minimumTimestamp!.timeIntervalSince1970))
        let userid = "happy"
        let timestamp = 3
        let res = MoodProveHTTP.getRequest(urlRequest: "\(moodProveServerDomain)/mood/beforeOrAfter?userid=\(userid)&timestamp=\(timestamp)&type=after")
        self.handleChangeInMoodTime(json: res)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // OAuth Login Sequence Test
        // oauthLogin();
        // Getting the current date to create fake data
        let date = Date()
        minimumTimestamp = date.timeIntervalSince1970
        retrieveBarChartData(currentDate: date.timeIntervalSince1970)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    
    }
    
    func setUpBarChart(barChartEntries: [ChartDataEntry], earlistTimeInRetrievedEntries: TimeInterval) {
        
        // Set up Date Formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.locale = Locale.current
        
        // Set up xValuesFormatter for the chart
        let xValuesNumberFormatter = ChartXAxisValueFormatter(referenceTimeInterval: earlistTimeInRetrievedEntries, dateFormatter: formatter)
        
        let xAxis = moodDataChart.xAxis
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        xAxis.valueFormatter = xValuesNumberFormatter
        
        
        let barChartDataSet = BarChartDataSet(values: barChartEntries, label: nil)
        barChartDataSet.colors = [NSUIColor.magenta]
        let data = BarChartData(dataSets: [barChartDataSet])
        moodDataChart.data = data
        
        
        moodDataChart.leftAxis.axisMinimum = 0
        moodDataChart.leftAxis.axisMaximum = 63
        
        // Allow users to see a bar cell highlighted when tapped.
        moodDataChart.highlightPerTapEnabled = true
        //moodDataChart.drawGridBackgroundEnabled = true
        
        // Remove labels from both left and right axis.
        moodDataChart.leftAxis.drawLabelsEnabled = false
        moodDataChart.rightAxis.drawLabelsEnabled = false
        
        // Remove all the premade grid lines from the bar chart.
        moodDataChart.xAxis.drawGridLinesEnabled = false
        moodDataChart.leftAxis.drawGridLinesEnabled = false
        moodDataChart.rightAxis.drawGridLinesEnabled = false

        // Set the xAxis font
        moodDataChart.xAxis.labelFont = NSFont.messageFont(ofSize: CGFloat.init(15))
        
        // Remove description label
        moodDataChart.chartDescription?.text = ""
        
        // Disabling zoom
        moodDataChart.pinchZoomEnabled = false
        moodDataChart.dragEnabled = false
        moodDataChart.setScaleEnabled(false)
        
        let limitLinesValues: [Double] = [0, 10, 20, 30, 40, 50, 60]
        let limitLinesColors: [NSUIColor] = [NSUIColor.black, NSUIColor.brown, NSUIColor.blue, NSUIColor.cyan, NSUIColor.yellow,
                                             NSUIColor.green, NSUIColor.purple]
        for k:Int in 0 ..< limitLinesValues.count {
            let limitLine = ChartLimitLine()
            limitLine.lineColor = limitLinesColors[k]
            limitLine.limit = limitLinesValues[k]
            limitLine.label = "Mood"
            limitLine.lineWidth = 2.0
            moodDataChart.leftAxis.addLimitLine(limitLine)
            
        }
        
        //moodDataChart.animate(xAxisDuration: 5000, yAxisDuration: 5000)
        moodDataChart.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        moodDataChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        moodDataChart.delegate = self
    }
    
    func retrieveBarChartData(currentDate: Double) {
        var dataEntries: [ChartDataEntry] = []
        
        
        // Mock Data
        let date_1: Date = Calendar.current.date(byAdding: .day, value: 8, to: Date())!
        let date_2: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        let date_3: Date = Calendar.current.date(byAdding: .day, value: 6, to: Date())!
        let date_4: Date = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        let date_5: Date = Calendar.current.date(byAdding: .day, value: 4, to: Date())!
        let date_6: Date = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        let date_7: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        let date_8: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let date_9: Date = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        
        let num_data_1: TimeInterval = date_1.timeIntervalSince1970
        let num_data_2: TimeInterval = date_2.timeIntervalSince1970
        let num_data_3: TimeInterval = date_3.timeIntervalSince1970
        let num_data_4: TimeInterval = date_4.timeIntervalSince1970
        let num_data_5: TimeInterval = date_5.timeIntervalSince1970
        let num_data_6: TimeInterval = date_6.timeIntervalSince1970
        let num_data_7: TimeInterval = date_7.timeIntervalSince1970
        let num_data_8: TimeInterval = date_8.timeIntervalSince1970
        let num_data_9: TimeInterval = date_9.timeIntervalSince1970
    
        
        dataEntries.append(BarChartDataEntry(x: (num_data_9 - num_data_9) / (3600 * 24), y: 14.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_8 - num_data_9) / (3600 * 24), y: 27.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_7 - num_data_9) / (3600 * 24), y: 55.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_6 - num_data_9) / (3600 * 24), y: 38.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_5 - num_data_9) / (3600 * 24), y: 3.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_4 - num_data_9) / (3600 * 24), y: 32.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_3 - num_data_9) / (3600 * 24), y: 43.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_2 - num_data_9) / (3600 * 24), y: 49.0))
        dataEntries.append(BarChartDataEntry(x: (num_data_1 - num_data_9) / (3600 * 24), y: 21.0))
        
        setUpBarChart(barChartEntries: dataEntries, earlistTimeInRetrievedEntries: num_data_9)
    }

    func oauthLogin() {
        let link = "https://www.facebook.com/dialog/oauth?client_id=" + MoodProveAPIKeys.FacebookClientID + "&redirect_uri=http://localhost:8080/auth/facebook&response_type=code"
        

        if let url = URL(string: link), NSWorkspace.shared().open(url) {
            print("Opening in default web browser...")
        }

          
    }
    
    func convertDataToChartData(retreivedDataEntries: [TimeInterval : Int]) {
        var dataEntries: [ChartDataEntry] = []
        
        for (key, value) in retreivedDataEntries {
            dataEntries.append(BarChartDataEntry(x: (key - minimumTimestamp!) / (3600 * 24), y: Double(value)))
        }
    
        setUpBarChart(barChartEntries: dataEntries, earlistTimeInRetrievedEntries: minimumTimestamp!)
    }
    
    func handleChangeInMoodTime(json: JSON) {
        if (json == JSON.null || json["data"].stringValue == "No Valid Data") {
            print("No valid data to show for request")
            return
        }
        else if (json["data"] == "Request Invalid") {
            print("Invalid Request")
            return
        }
        
        var moodProveData = [TimeInterval : Int]()
        
        for (_, subJson) in json["data"] {
            if let timestamp = subJson["timestamp"].int64 {
                if let moodPrediction = subJson["mood"].int {
                    moodProveData[TimeInterval(timestamp)] = moodPrediction
                }
            }
        }
        
        let sortedDictionary = moodProveData.sorted(by: { $0.0.key < $0.1.key })
        
        maximumTimestamp = sortedDictionary.last?.key
        minimumTimestamp = sortedDictionary.first?.key
    }
    
    // Could be useful in the future
    func bringToFront() {
        let window = self.view.window
        window?.collectionBehavior = NSWindowCollectionBehavior.moveToActiveSpace
    }
    
}


