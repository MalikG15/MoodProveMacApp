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

class MainViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate, ChartViewDelegate {
    
    // MARK: - Class Member Variables
    var userId: String?
    
    var name: String?
    
    var newUser: Bool?
    
    var openAnotherWindow: NSWindow?
    
    let moodProveServerDomain: String = "http://localhost:8080"
    
    
    // MARK: - ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Check to see how to load the view
        /*if (newUser! == true || userHasEnoughMoodHistory()) {
         let response = getCheckInTimes()
         if (response == "Now") {
         titleOnMainView.isHidden = true
         descriptionForCheckIn.isHidden = true
         }
         else {
         checkInMood.isHidden = true
         }
         titleOnMainView.stringValue = getCheckInTimes()
         descriptionForCheckIn.stringValue = "\(name!)'s Next Check-In with MoodProve is:"
         
         return
         }*/
        
        // Set up mood overview collection view
        moodOverviewCollectionViewLayoutConfiguration()
        
        // Set up mood detail collection view
        moodDetailCollectionViewLayoutConfiguration()
        
        // Set up mood friend status collection view
        moodFriendStatusCollectionViewLayoutConfiguration()
        
        checkInMood.isHidden = true
        descriptionForCheckIn.isHidden = true
        
        setPieChart(dataPoints: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"], values: [10.0, 4.0, 6.0, 3.0, 12.0, 16.0])
    }
    
    
    // MARK: - Mood Overview
    
    @IBOutlet weak var moodOverviewCollectionView: NSCollectionView!
    
    @IBOutlet weak var pastOrPredictedMoodToggleButton: NSSegmentedControl!
    
    @IBOutlet weak var moodTimeSelection: NSDatePicker!
    
    @IBAction func pastOrPredictedMoodToggle(_ sender: Any) {
        // User wants to view past mood
        if (pastOrPredictedMoodToggleButton.selectedSegment == 0) {
            moodTimeSelection.isHidden = false
            
            // get value of moodTimeSelection and display data
        }
            // User want to view predicted mood
        else {
            moodTimeSelection.isHidden = true
        }
    }
    
    func moodOverviewCollectionViewLayoutConfiguration() {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 200, height: 100)
        layout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        moodOverviewCollectionView.collectionViewLayout = layout
        
        moodOverviewCollectionView.dataSource = self
        moodOverviewCollectionView.delegate = self
    }
    
    // MARK: - Mood Detail
    
    @IBOutlet weak var moodDetailCollectionView: NSCollectionView!
    
    @IBOutlet weak var mainPieChartView: PieChartView!
    
    
    func setPieChart(dataPoints: [String], values: [Double]) {
        var entries = [PieChartDataEntry]()
        
        for (index, value) in values.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = dataPoints[index]
            entries.append(entry)
        }
        
        let dataSet = PieChartDataSet(values: entries, label: "")
        
        var colors: [NSColor] = []
        
        for _ in 0..<values.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = NSColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        dataSet.colors = colors
        let data = PieChartData(dataSet: dataSet)
        mainPieChartView.data = data
        
        
        mainPieChartView.animate(xAxisDuration: 1.5)
        
        mainPieChartView.chartDescription?.text = ""
    }
    
    func moodDetailCollectionViewLayoutConfiguration() {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 200, height: 100)
        layout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        moodDetailCollectionView.collectionViewLayout = layout
        
        moodDetailCollectionView.dataSource = self
        moodDetailCollectionView.delegate = self
    }
    

    // MARK: - Friend Search
    
    @IBOutlet weak var moodFriendStatusCollectionView: NSCollectionView!
    
    @IBOutlet weak var friendSearchTextField: NSTextField!
    
    func moodFriendStatusCollectionViewLayoutConfiguration() {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 200, height: 100)
        layout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        moodFriendStatusCollectionView.collectionViewLayout = layout
        
        moodFriendStatusCollectionView.dataSource = self
        moodFriendStatusCollectionView.delegate = self

    }
    
    // MARK: - Check In
    
    @IBOutlet weak var descriptionForCheckIn: NSTextField!
    
    @IBOutlet weak var checkInMood: NSButton!
    
    @IBAction func checkIn(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let reportMoodViewController: ReportMoodViewController = storyboard.instantiateController(withIdentifier: "reportMoodVC") as! ReportMoodViewController
        reportMoodViewController.userId = userId!
        openAnotherWindow = NSWindow(contentViewController: reportMoodViewController)
        openAnotherWindow?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: openAnotherWindow)
        vc.showWindow(self)
    }
    
    func userHasEnoughMoodHistory() -> Bool {
        let path = "/past/check?userid=\(userId!)"
        print(MoodProveHTTP.moodProveDomain + path)
        let moodHistory = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
        
        print(moodHistory["data"].stringValue)
        if (moodHistory["data"].stringValue == "Sufficient") {
            return false
        }
        
        return true
    }
    
    func getCheckInTimes() -> String {
        let currentDate: Date = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let path = "/predicted/getCheckInInterval?userid=\(userId!)&timestamp=\(Int64(currentDate.timeIntervalSince1970))"
        print(MoodProveHTTP.moodProveDomain + path)
        let moodHistory = MoodProveHTTP.getRequest(urlRequest: MoodProveHTTP.moodProveDomain + path)
        
        return moodHistory["checkInInterval"].stringValue
    }
    
    
    // MARK: - Settings
    
    @IBAction func settings(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main",bundle: nil)
        let completeSettingsViewController: CompleteSettingsViewController = storyboard.instantiateController(withIdentifier: "completeSettingsView") as! CompleteSettingsViewController
        completeSettingsViewController.userId = userId!
        openAnotherWindow = NSWindow(contentViewController: completeSettingsViewController)
        openAnotherWindow?.makeKeyAndOrderFront(self)
        let vc = NSWindowController(window: openAnotherWindow)
        vc.showWindow(self)
    }
    
    // MARK: - Miscellaneous

    @IBOutlet weak var titleOnMainView: NSTextField!
    
    
    // MARK: - General CollectionView Configuration
    
    // Delegate
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if (collectionView == moodOverviewCollectionView) {
            let overviewItem = collectionView.makeItem(withIdentifier: "MoodOverviewCollectionViewItem", for: indexPath)
            overviewItem.textField?.stringValue = "done ++\n testing"
            return overviewItem
        }
        else if (collectionView == moodDetailCollectionView) {
            let detailItem = collectionView.makeItem(withIdentifier: "MoodDetailCollectionViewItem", for: indexPath)
            return detailItem
        }
        else {
            let overviewItem = collectionView.makeItem(withIdentifier: "MoodFriendStatusCollectionViewItem", for: indexPath)
            return overviewItem
        }

    }
    
    // Data Source
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
}


