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


class OrderSummeryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    var arrRes = [[String:AnyObject]]()
    private let cellReuseIdentifier: String = "cell"
    var totalpriceorder = ""
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tblorderSummery: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.selectedItem = tabBar.items![2]
        
        tblorderSummery.delegate = self
        tblorderSummery.dataSource = self
        tblorderSummery.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tabBar.delegate = self
        
//        http://192.168.1.164:8181/api/ordersummary/getorderSummary/1012019.03.12.16.33.47121
         let urllink = GVBaseURL+"ordersummary/getorderSummary/\(userIDofuser)"
        print(urllink)
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
        return self.arrRes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        
        
        if indexPath.row == self.arrRes.count {
            let lblAmount = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
            lblAmount.text = "Total amount"
            lblAmount.font = UIFont.boldSystemFont(ofSize: 20.0)
            lblAmount.adjustsFontSizeToFitWidth = true
            cell.addSubview(lblAmount)
            
            let lblTotal = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 0, width: 50, height: 30))
            lblTotal.text = "\(totalpriceorder)"
            lblTotal.font = UIFont.boldSystemFont(ofSize: 20.0)
            lblTotal.adjustsFontSizeToFitWidth = true
            cell.addSubview(lblTotal)
        }else{
        
            var dict = arrRes[indexPath.row]
                let lblName = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
                lblName.text = dict["menuItemName"] as? String
                lblName.numberOfLines = 1
                lblName.minimumScaleFactor = 0.5
                lblName.adjustsFontSizeToFitWidth = true
                cell.addSubview(lblName)
            
            totalpriceorder = (dict["totalPrice"] as? String)!
            
                let lblNumber = UILabel(frame: CGRect(x: lblName.frame.origin.x+lblName.frame.size.width+30, y: 10, width: 30, height: 20))
                lblNumber.text = "\(dict["quantity"]!)"
                lblNumber.textColor = UIColor.black
                lblNumber.textAlignment = .center
                cell.addSubview(lblNumber)
            
            
                let tmpvar = Int(dict["quantity"]! as! NSNumber) * Int(dict["price"]! as! NSNumber)
            
                let lblPrice = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 10, width: 50, height: 20))
                lblPrice.text =  "$\(tmpvar)"   //"\(dict["price"]!)"
                cell.addSubview(lblPrice)
            
        }
           return cell
        
    }
    
    
    //MARK: tab bar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item \(item.tag)")
        
        if item.tag == 0{
            let displayVC : MainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.present(displayVC, animated: true, completion: nil)
        }else if(item.tag == 1){
            let displayVC : CartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.present(displayVC, animated: true, completion: nil)
        }
        
        
    }
    
}

   

