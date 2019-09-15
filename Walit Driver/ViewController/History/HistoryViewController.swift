//
//  HistoryViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var viewEarned: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var viewTotalJobs: UIView!
    
    @IBOutlet weak var tblView: UITableView!
    var arrRideHistory = [RideHistory]()
    
    @IBOutlet weak var lblTotalJobs: UILabel!
    
    @IBOutlet weak var lblEarned: UILabel!
    
     let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDatePicker.isHidden = true
        // Do any additional setup after loading the view.
        getData(date: "")
        self.tblView.estimatedRowHeight = 238
        self.tblView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = viewTotalJobs.frame.size
        gradientLayer.colors = [myColors.gradientLow.cgColor, myColors.gradientHigh.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        viewTotalJobs.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
        self.viewEarned.layer.cornerRadius  = 10
        self.viewEarned.clipsToBounds = true
        
        self.viewTotalJobs.layer.cornerRadius  = 10
        self.viewTotalJobs.clipsToBounds = true
    }
    @IBAction func btnCalendar(_ sender: Any) {
        if self.viewDatePicker.isHidden == true{
            self.viewDatePicker.isHidden = false
        }else{
            self.viewDatePicker.isHidden = true
        }
    }
    @IBAction func btnDone(_ sender: Any) {
        self.viewDatePicker.isHidden = true
        let date = formatter.string(from: datePicker.date)
        self.getData(date: date)
    }
    @IBAction func btnCancel(_ sender: Any) {
        self.viewDatePicker.isHidden = true
    }
    func getData(date:String){
        HistoryHandler.manager.getRideHistory(date: date, completion: { result,success,message,crditAmt,debitAmt  in
            self.arrRideHistory.removeAll()
            for item in result{
                let rideHistory = RideHistory()
                rideHistory.getData(dict: item as! NSDictionary)
                self.arrRideHistory.append(rideHistory)
            }
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.lblTotalJobs.text = "Total jobs \n \(crditAmt)"
                self.lblEarned.text = "Total Eraned \n \(debitAmt)"
                
            }
        })
    }
}
extension HistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRideHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        cell.configureCell(self.arrRideHistory[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostoryDetailViewController") as! HostoryDetailViewController
        vc.history = self.arrRideHistory[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
