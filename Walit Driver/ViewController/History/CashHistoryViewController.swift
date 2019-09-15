//
//  CashHistoryViewController.swift
//  Walit Driver
//
//  Created by Kavita on 17/06/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

class CashHistoryViewController: UIViewController {
    var arrCredit = [CashHistory]()
    var arrDebit = [CashHistory]()
    var index = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblDebit: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryHandler.manager.getHistory(completion: { result,success,message ,type,crditAmt,debitAmt  in
                print(result)
            for item in result{
                  let cashHistory = CashHistory()
                  cashHistory.getData(dict: item as! NSDictionary)
                  self.arrCredit.append(cashHistory)
            }
            for item in type{
                let cashHistory = CashHistory()
                cashHistory.getData(dict: item as! NSDictionary)
                self.arrDebit.append(cashHistory)
            }
            DispatchQueue.main.async {
                self.lblDebit.text = debitAmt
                self.lblCredit.text = crditAmt
                
                self.tableView.reloadData()
            }
            })
        // Do any additional setup after loading the view.
    }
  
    @IBAction func btnCredit(_ sender: UIButton) {
        imageLeadingConstraints.constant = sender.frame.origin.x
        self.index = 0
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnDebit(_ sender: UIButton) {
        imageLeadingConstraints.constant = sender.frame.origin.x
        self.index = 1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
}
extension CashHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 0{
          return arrCredit.count
        }else{
          return arrDebit.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CashHistoryTableViewCell", for: indexPath) as! CashHistoryTableViewCell
        if index == 0{
            cell.configureCell(cashHistory:arrCredit[indexPath.row])
        }else{
            cell.configureCell(cashHistory:arrDebit[indexPath.row])
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
