//
//  OrderSummeryViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 14/03/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class OrderSummeryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrRes = [[String:AnyObject]]()
    private let cellReuseIdentifier: String = "cell"
    
    @IBOutlet weak var tblorderSummery: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tblorderSummery.delegate = self
        tblorderSummery.dataSource = self
        tblorderSummery.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
//        http://192.168.1.164:8181/api/ordersummary/getorderSummary/1012019.03.12.16.33.47121
         let urllink = GVBaseURL+"ordersummary/getorderSummary/\(orderIDis)"
        Alamofire.request(urllink).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
        
                if let resData = swiftyJsonVar.arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("data is as follow \(self.arrRes) \(self.arrRes.count)")
                }
                if self.arrRes.count>0{
                    self.tblorderSummery.reloadData()
                }
            }
        }
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
         var dict = arrRes[indexPath.row]
        
        let lblName = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
        lblName.text = dict["menuItemName"] as? String
        lblName.numberOfLines = 1
        lblName.minimumScaleFactor = 0.5
        lblName.adjustsFontSizeToFitWidth = true
        cell.addSubview(lblName)
        
        let lblNumber = UILabel(frame: CGRect(x: lblName.frame.origin.x+lblName.frame.size.width+30, y: 10, width: 30, height: 20))
        lblNumber.text = "\(dict["quantity"]!)"
        lblNumber.textColor = UIColor.black
        lblNumber.textAlignment = .center
        cell.addSubview(lblNumber)
        
        
        let tmpvar = Int(dict["quantity"]! as! NSNumber) * Int(dict["price"]! as! NSNumber)
        
        let lblPrice = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 10, width: 50, height: 20))
        lblPrice.text =  "\(tmpvar)"   //"\(dict["price"]!)"
        cell.addSubview(lblPrice)
        
        
        return cell
        
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


