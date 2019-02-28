//
//  MenuViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 25/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    var arrRes = [[String:AnyObject]]()
    var arrCatagory:Array<Any> = []
    var countofCart = 0
    
    
    
    
    
    //    let cellReuseIdentifier = "cell"
    private let cellReuseIdentifier: String = "cell"

    @IBOutlet weak var lblcartNum: UILabel!
    @IBOutlet weak var tblMenus: UITableView!
    @IBOutlet weak var scrollViewBtn: UIScrollView!
    var buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10
    
    var ddata:String = ""
//    var resturantId:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ddata is \(ddata)")
        print("resturantId is \(resturantId)")
        
        arrCatagory = ["Soup","Salad","Breakfast","Lunch","Dinner","Kids Menu","Desserts","Back"]
        
        UIJscrollBtn()
        
        tblMenus.dataSource = self
        tblMenus.dataSource = self
        tblMenus.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tblMenus.backgroundColor = UIColor.clear
        
        
        lblcartNum.layer.cornerRadius = lblcartNum.frame.width/2
        lblcartNum.layer.masksToBounds = true
        
        dictTest["prize"] = []
        dictTest["listNo"] = []
        dictTest["quantity"] = []
        dictTest["menuList"] = []
        
        
        if countofCart == 0{
            lblcartNum.isHidden = true
        }else{
            lblcartNum.isHidden = false
        }
        
         self.navigationController?.isNavigationBarHidden = false
        
//        let urlMenuCatagory = GVBaseURL + "restaurantmenu/selectbyid/\(resturantId)/\(catagoryId)"
        let urllink = GVBaseURL+"restaurantmenu/selectbyid/\(resturantId)/1001"
        Alamofire.request(urllink).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar.arrayObject{
                    self.arrRes = resData as! [[String:AnyObject]]
                    print("data is as follow \(self.arrRes) \(self.arrRes.count)")
                }
                if self.arrRes.count>0{
                    self.tblMenus.reloadData()
                }
                
                
            }
        }
    }
    
    //MARK: Design of scroll btn
    func UIJscrollBtn(){
        
        
        for i in 0...7{
           
            let button = UIButton()
            button.tag = i
            button.backgroundColor = UIColor(displayP3Red: 131/255, green: 156/255, blue: 96/255, alpha: 1)
            button.setTitle("\(arrCatagory[i])", for: .normal)
            button.addTarget(self, action: #selector(btnTouch), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 100, height: 30)
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scrollViewBtn.addSubview(button)
            
        }
        scrollViewBtn.contentSize = CGSize(width: xOffset, height: scrollViewBtn.frame.height)
        
    }
    
    //MARK: catagory select buttons and back btn
    @IBAction func btnBackPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func btnTouch(sender:UIButton){
        var urllink = ""

        catagoryId = sender.tag + 1 + 1000
        if sender.tag == 0{
            arrRes.removeAll()
//            catagoryId = 1001

        }else if sender.tag == 1{
            arrRes.removeAll()
//            catagoryId = 1002
//            urllink = "http://192.168.1.5:8080/api/restaurantmenu/selectbyid/\(resturantId)/1002"
        }else if sender.tag == 2{
            arrRes.removeAll()
//            catagoryId = 1003
//            urllink = "http://192.168.1.5:8080/api/restaurantmenu/selectbyid/\(resturantId)/1003"
        }else if sender.tag == 3{
            arrRes.removeAll()
//            catagoryId = 1004
//            urllink = "http://192.168.1.5:8080/api/restaurantmenu/selectbyid/\(resturantId)/1004"
        }else if sender.tag == 4{
            arrRes.removeAll()
//            catagoryId = 1005
//            urllink = "http://192.168.1.5:8080/api/restaurantmenu/selectbyid/\(resturantId)/1005"
        }else if sender.tag == 5{
            arrRes.removeAll()
//            catagoryId = 1006
//            urllink = "http://192.168.1.5:8080/api/restaurantmenu/selectbyid/\(resturantId)/1006"
        }else if sender.tag == 6{
            arrRes.removeAll()
//            catagoryId = 1007
//            urllink = "http://192.168.1.5:8080/api/restaurantmenu/selectbyid/\(resturantId)/1007"
        }
        else if sender.tag == 7{
            self.dismiss(animated: true, completion: nil)
        }
        
        let urlMenuCatagory = GVBaseURL + "restaurantmenu/selectbyid/\(resturantId)/\(catagoryId)"
        print("\(catagoryId)")
        print("url is \(urlMenuCatagory)")
                Alamofire.request(urlMenuCatagory).responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        print(swiftyJsonVar)
                        
                        if let resData = swiftyJsonVar.arrayObject{
                            self.arrRes = resData as! [[String:AnyObject]]
                            print("data is as follow \(self.arrRes) \(self.arrRes.count)")
                        }
                        if self.arrRes.count>0{
                            self.tblMenus.reloadData()
                        }
                        
                        
                    }
                }
        
        
    }
    
    //MARK: TableView Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var dict = arrRes[indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        
        let imgMenus = UIImageView(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width-40, height: 110) )
                var imageUrlString = dict["menuImage"]as! String
                imageUrlString = GVImageBaseURL + imageUrlString
                 let imageUrl:URL = URL(string: imageUrlString)!
        
                // Start background thread so that image loading does not make app unresponsive
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData as Data)
                        imgMenus.image = image
//                        imgMenus.contentMode = UIView.ContentMode.scaleAspectFit
                    }
                }
        cell.addSubview(imgMenus)
        
        let lblNumber = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 40))
        lblNumber.backgroundColor = UIColor.lightText
        lblNumber.text = "\(indexPath.row+1)"
        lblNumber.textAlignment = .center
        lblNumber.font = lblNumber.font.withSize(40)
        imgMenus.addSubview(lblNumber)
        
        let lblMenuName = UILabel(frame: CGRect(x: 0, y: imgMenus.frame.size.height-40, width: UIScreen.main.bounds.size.width-40, height: 30))
        lblMenuName.backgroundColor = UIColor.init(red: 25/255, green: 27/255, blue: 11/255, alpha: 0.5)
        lblMenuName.text = dict["menuList"] as? String
        lblMenuName.textColor = UIColor.white
        imgMenus.addSubview(lblMenuName)
        
        let btnadd = UIButton(frame: CGRect(x: 20, y: imgMenus.frame.origin.y+imgMenus.frame.size.height, width: UIScreen.main.bounds.size.width-40, height: 30))
        btnadd.backgroundColor = UIColor.orange
        btnadd.setTitle("ADD", for: UIControl.State.normal)
        btnadd.tag = indexPath.row
        btnadd.addTarget(self, action: #selector(btnAddTocart), for: UIControl.Event.touchUpInside)
        cell.addSubview(btnadd)
     
        return cell
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;//Choose your custom row height
    }
    
    @objc func btnAddTocart(sender:UIButton){
        print("\(sender.tag)")
        lblcartNum.isHidden = false
        countofCart = countofCart + 1
        lblcartNum.text = "\(countofCart)"
        
        let dict = arrRes[sender.tag]
       
        let listNo = dict["listNo"]
        let prize = dict["prize"]!
        let menuList = dict["menuList"]!
        
       print("data is \(dict)")
        
//        let data: [String: Any] = [
//            "listNo": listNo as Any,
//            "prize": prize as Any,
//            "quantity": 1
//        ]
        
    
//        arrCardItem.updateValue(listNo!, forKey: "listNo")
        
        if var arr = dictTest["listNo"] {
            arr.append(listNo as! Int)
            dictTest["listNo"] = arr
        } else {
            print("first")
            dictTest["listNo"] = listNo as? [Int]
        }
        
        if var arr = dictTest["prize"] {
            arr.append(prize as Any)
            dictTest["prize"] = arr
        } else {
            dictTest["prize"] = (prize as! [Any])
        }
        
        if var arr = dictTest["quantity"] {
            arr.append(1)
            dictTest["quantity"] = arr
        } else {
            dictTest["quantity"] = ([1] as [Int])
        }
        
        if var arr = dictTest["menuList"] {
            arr.append(menuList)
            dictTest["menuList"] = arr
        } else {
            print("hey/n/n/t")
            dictTest["menuList"] = (menuList) as? [Any]
        }
        
        print("all data is \(dictTest)")
        
    }
    

   

}
