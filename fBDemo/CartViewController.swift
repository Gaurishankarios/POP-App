//
//  CartViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 28/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Stripe

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {

    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    let arrMenulist = dictTest["menuItemName"]
    let arrquantity = dictTest["quantity"]
    let arrprice = dictTest["price"]
    let arrlistNo = dictTest["menuId"]
    
    var total = 0
    
    private let cellReuseIdentifier: String = "cell"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("cart data is \(dictTest)")
        
       tabBar.selectedItem = tabBar.items![1]
        
        tblCart.delegate = self
        tblCart.dataSource = self
        // Do any additional setup after loading the view.
        tblCart.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tabBar.delegate = self
        
//        let alertController = UIAlertController()
        
        if dictTest.count > 1{
             amountCalculate()
        }
      
        
        print("arrquantity is \(String(describing: arrquantity))")
        print("menuList is \(String(describing: arrMenulist))")
        print("arrprice is \(String(describing: arrprice))")
        print("arrlistNo is \(String(describing: arrlistNo)) \(String(describing: arrlistNo?.count))")
        
//        self.navigationController?.navigationBar.isHidden = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self as? STPAddCardViewControllerDelegate
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tblCart.reloadData()
    }
    
    //MARK: TableViewData source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrlistNo?.count ?? 0
        return (dictTest["menuId"]?.count)! + 1
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        
        
        if indexPath.row == (dictTest["menuId"]?.count)! {
            let lblAmount = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
            lblAmount.text = "Total amount"
            lblAmount.font = UIFont.boldSystemFont(ofSize: 20.0)
            lblAmount.adjustsFontSizeToFitWidth = true
            cell.addSubview(lblAmount)
            
            let lblTotal = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 0, width: 50, height: 30))
            lblTotal.text = "$\(total)"
            lblTotal.font = UIFont.boldSystemFont(ofSize: 20.0)
            lblTotal.adjustsFontSizeToFitWidth = true
            cell.addSubview(lblTotal)
        }else{
                let lblName = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
            lblName.text = dictTest["menuItemName"]![indexPath.row] as? String
                lblName.numberOfLines = 1
                lblName.minimumScaleFactor = 0.5
                lblName.adjustsFontSizeToFitWidth = true
                cell.addSubview(lblName)
        
                let btnsubtract = UIButton(frame: CGRect(x: lblName.frame.origin.x+lblName.frame.size.width+5, y: 5, width: 30, height: 30))
                btnsubtract.setTitle("-", for: UIControl.State.normal)
                btnsubtract.backgroundColor = UIColor.green //UIColor(red: 0.72, green: 0.74, blue: 0.4, alpha: 1)
                btnsubtract.layer.cornerRadius = 15
                btnsubtract.tag = indexPath.row
                btnsubtract.addTarget(self, action: #selector(btnSubstractPress), for: UIControl.Event.touchUpInside)
                cell.addSubview(btnsubtract)
        
                let lblNumber = UILabel(frame: CGRect(x: btnsubtract.frame.origin.x+btnsubtract.frame.size.width, y: 10, width: 30, height: 20))
        //        print(arrquantity![indexPath.row] as Any)
        //        lblNumber.text = "\(arrquantity![indexPath.row] as Any)"
                lblNumber.text = "\(dictTest["quantity"]![indexPath.row])"
                lblNumber.textColor = UIColor.black
                lblNumber.textAlignment = .center
                cell.addSubview(lblNumber)
        
                let btnadd = UIButton(frame: CGRect(x: lblNumber.frame.origin.x+lblNumber.frame.size.width, y: 5, width: 30, height: 30))
                btnadd.setTitle("+", for: UIControl.State.normal)
                btnadd.backgroundColor = UIColor.green
                btnadd.layer.cornerRadius = 15
                btnadd.tag = indexPath.row
                btnadd.addTarget(self, action: #selector(btnAddPress), for: UIControl.Event.touchUpInside)
                cell.addSubview(btnadd)
        
                let lblPrice = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 10, width: 50, height: 20))
                lblPrice.text = dictTest["price"]![indexPath.row] as! String
                cell.addSubview(lblPrice)
        
        }
        
        return cell
    }
    
    
    //MARK: btn Add and Subtract logic
    @objc func btnSubstractPress(sender:UIButton){
        let tmpvalue =  dictTest["quantity"]![sender.tag] as! Int
        
       total = 0
        if tmpvalue == 1{

             dictTest["quantity"]?.remove(at: sender.tag)
            dictTest["price"]?.remove(at: sender.tag)
            dictTest["menuItemName"]?.remove(at: sender.tag)
            dictTest["menuId"]?.remove(at: sender.tag)
            print(dictTest["quantity"]?.count)
            print("final data is \(dictTest)")
            
            countofCart = countofCart - 1
             tblCart.reloadData()
        }
        if tmpvalue>1{
        
            dictTest["quantity"]![sender.tag] = tmpvalue - 1
        
            let tmpprice =  dictTest["price"]![sender.tag] as! String
            let editedText = tmpprice.replacingOccurrences(of: "$", with: "")
            let temp2 = Int(editedText)
        
            let temp3 = temp2!/(tmpvalue)
            let tmp4 = temp3 * (tmpvalue - 1)
        
        
        
            let strtmp = "$\(tmp4)"
            print(strtmp)
        
            dictTest["price"]![sender.tag] = strtmp
        
            tblCart.reloadData()
        }
        amountCalculate()
        
    }
    @objc func btnAddPress(sender:UIButton){
        
        total = 0
        
        let tmpvalue =  dictTest["quantity"]![sender.tag] as! Int
        dictTest["quantity"]![sender.tag] = tmpvalue + 1
 
        let tmpprice =  dictTest["price"]![sender.tag] as! String
        let editedText = tmpprice.replacingOccurrences(of: "$", with: "")
        let temp2 = Int(editedText)
        
        let temp3 = temp2!/(tmpvalue)
        let tmp4 = temp3 * (tmpvalue + 1)
        
        
        
        let strtmp = "$\(tmp4)"
        print(strtmp)
        
        dictTest["price"]![sender.tag] = strtmp
        
        tblCart.reloadData()
        
        amountCalculate()
    }
    
    //MARK: Total price calculation
    
    func amountCalculate() {
//        dictTest["price"]
        for arr in dictTest["price"] ?? [0] {
            let tmpprice =  arr as! String
            let tmp = tmpprice.replacingOccurrences(of: "$", with: "")
            let temp2 = Int(tmp)
            total = total + temp2!
            
            
            
        }
        stripeTotal = total
    }
    
    
    
    @IBAction func btnBackPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Pay Later btn and update to server
    @IBAction func btnPayLaterPes(_ sender: Any) {
        
        let url = "http://182.73.184.62:443/api/order/addOrder" // This will be your link
        let parameters: Parameters = ["userId": userIDofuser, "restaurantId": resturantId, "menuId": dictTest["menuId"]!, "quantity": dictTest["quantity"]!, "totalPrice": "$\(total)", "paymentStatus": "false", "orderStartTime": "asassa" ]      //This will be your parameter
        print("\(parameters)")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            
            let swiftyJsonVar = JSON(response.result.value!)
            
            if let name = swiftyJsonVar["orderId"].string {
                // get name
                orderIDis = name
                
                print("\(name)")
                let displayVC : ShowQRViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowQRViewController") as! ShowQRViewController
                self.present(displayVC, animated: true, completion: nil)
                
                
                dictTest.removeAll()
                print("data is remove \(dictTest)")
                dictTest["price"] = []
                dictTest["menuId"] = []
                dictTest["quantity"] = []
                dictTest["menuItemName"] = []
                dictTest["restID"] = []
                countofCart = 0
                resturantIdTest = 0
            }

        }
    }
    
    //MARK: tab bar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item \(item.tag)")
        
        if item.tag == 0{
            let displayVC : MainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.present(displayVC, animated: true, completion: nil)
        }else if(item.tag == 2){
            let displayVC : OrderSummeryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderSummeryViewController") as! OrderSummeryViewController
            self.present(displayVC, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func btnPayNowPress(_ sender: Any) {
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self as? STPAddCardViewControllerDelegate
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
//        navigationController.pushViewController(addCardViewController, animated: true)
    }
}
//MARK: Extension
extension CartViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        MyAPIClient.sharedClient.completeCharge(with: token, amount: 100) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
//                var alert = AlertController()
//                alert.showAlert()
                
                let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                    
                    let url = GVBaseURL + "order/addOrder" // This will be your link
                    let parameters: Parameters = ["userId": userIDofuser, "restaurantId": resturantId, "menuId": dictTest["menuId"]!, "quantity": dictTest["quantity"]!, "totalPrice": "$\(self.total)", "paymentStatus": "True", "orderStartTime": "asassa" ]      //This will be your parameter
                    print("\(parameters)")
                    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                        print(response)
                        
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if let name = swiftyJsonVar["orderId"].string {
                            // get name
                            orderIDis = name
                            
                            print("\(name)")
                            let displayVC : ShowQRViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowQRViewController") as! ShowQRViewController
                            self.present(displayVC, animated: true, completion: nil)
                            
                            dictTest.removeAll()
                            print("data is remove \(dictTest)")
                            dictTest["price"] = []
                            dictTest["menuId"] = []
                            dictTest["quantity"] = []
                            dictTest["menuItemName"] = []
                            dictTest["restID"] = []
                            countofCart = 0
                            resturantIdTest = 0
                        }
                        
                    }
                    
                })
                alertController.addAction(alertAction)
//                self.present(alertController, animated: true)
                addCardViewController.present(alertController, animated: true, completion: nil)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
        
        
        
    }
}
