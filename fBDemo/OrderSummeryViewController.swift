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
    @IBOutlet weak var lblETAstatus: UILabel!
    
    @IBOutlet weak var lblOrderstatus: UILabel!
    
    @IBOutlet weak var imgOrder: UIImageView!
    
    @IBOutlet weak var imgHotel: UIImageView!
    @IBOutlet weak var restName: UILabel!
    @IBOutlet weak var restAddr: UILabel!
    @IBOutlet weak var lblTrestName: UILabel!
    @IBOutlet weak var lblTrestAddr: UILabel!
    
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
        
        imgHotel.image = UIImage(named: "loader")
        
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
                    let tmp = self.arrRes[0]["orderStatus"]!
                    var imageUrlString = self.arrRes[0]["restaurantImage"] as! String
                    self.restName.text = self.arrRes[0]["restaurantName"] as? String
                    self.lblTrestName.text = self.restName.text
                    self.restAddr.text = self.arrRes[0]["restaurantArea"] as? String
                    self.lblTrestAddr.text = self.restAddr.text
                    print("order status is \(tmp)")
                    
                    if tmp as! String == "New Order"{
                        self.lblOrderstatus.text = "Your order is in inline.."
                        self.lblETAstatus.text = " "
                    }else if tmp as! String == "In Progress"{
                        self.lblOrderstatus.text = "The chef is doing his magic"
                        self.lblETAstatus.text = " "
                        self.imgOrder.image = UIImage(named: "cooking.png")
                    }else if tmp as! String == "Ready"{
                        self.lblOrderstatus.text = "Your Food is waiting for you"
                        self.lblETAstatus.text = " "
                        self.imgOrder.image = UIImage(named: "spaghetti.png")
                    }
                    
                    
                     imageUrlString =  GVImageBaseURL + imageUrlString
                    let imageUrl:URL = URL(string: imageUrlString)!
                    // Start background thread so that image loading does not make app unresponsive
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                        let imageData:NSData = NSData(contentsOf: imageUrl)!
                        
                        
                        // When from background thread, UI needs to be updated on main_queue
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData as Data)
                            self.imgHotel.image = image
                            self.imgHotel.contentMode = UIView.ContentMode.scaleAspectFit
                            
                        }
                    }
                    
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
    
    @IBAction func btnCallNowPress(_ sender: Any) {
        let tmpstr = arrRes[0]["restaurantPhoneNo"]
        dialNumber(number: tmpstr as! String)
    }
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    @IBAction func btnGetDirectionPress(_ sender: Any) {
        
        let primaryContactFullAddress = arrRes[0]["restaurantArea"]
        let testURL: NSURL = NSURL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(testURL as URL) {
            if let address = primaryContactFullAddress?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let directionsRequest: String = "comgooglemaps-x-callback://" + "?daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp"
                let directionsURL: NSURL = NSURL(string: directionsRequest)!
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(directionsURL as URL)) {
                    application.open(directionsURL as URL, options: [:], completionHandler: nil)
                }
            }
        } else {
            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
        }
        
    }
}


   

