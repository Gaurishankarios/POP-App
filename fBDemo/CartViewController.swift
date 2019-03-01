//
//  CartViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 28/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblCart: UITableView!
    
    let arrMenulist = dictTest["menuList"]
    let arrquantity = dictTest["quantity"]
    let arrprize = dictTest["prize"]
    let arrlistNo = dictTest["listNo"]
    
    var total = 0
    
    private let cellReuseIdentifier: String = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("cart data is \(dictTest)")
        
        tblCart.delegate = self
        tblCart.dataSource = self
        // Do any additional setup after loading the view.
        tblCart.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
       amountCalculate()
        
        print("arrquantity is \(String(describing: arrquantity))")
        print("menuList is \(String(describing: arrMenulist))")
        print("arrprize is \(String(describing: arrprize))")
        print("arrlistNo is \(String(describing: arrlistNo)) \(String(describing: arrlistNo?.count))")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrlistNo?.count ?? 0
        return (dictTest["listNo"]?.count)! + 1
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: cellReuseIdentifier)
        
        
        if indexPath.row == (dictTest["listNo"]?.count)! {
            let lblAmount = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
            lblAmount.text = "Total amount \(total)"
            lblAmount.numberOfLines = 1
            lblAmount.minimumScaleFactor = 0.5
            lblAmount.adjustsFontSizeToFitWidth = true
            cell.addSubview(lblAmount)
        }else{
                let lblName = UILabel(frame: CGRect(x: 5, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
                lblName.text = arrMenulist?[indexPath.row] as? String
                lblName.numberOfLines = 1
                lblName.minimumScaleFactor = 0.5
                lblName.adjustsFontSizeToFitWidth = true
                cell.addSubview(lblName)
        
                let btnsubtract = UIButton(frame: CGRect(x: lblName.frame.origin.x+lblName.frame.size.width+5, y: 10, width: 20, height: 20))
                btnsubtract.setTitle("-", for: UIControl.State.normal)
                btnsubtract.backgroundColor = UIColor.red
                btnsubtract.layer.cornerRadius = 10
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
        
                let btnadd = UIButton(frame: CGRect(x: lblNumber.frame.origin.x+lblNumber.frame.size.width, y: 10, width: 20, height: 20))
                btnadd.setTitle("+", for: UIControl.State.normal)
                btnadd.backgroundColor = UIColor.red
                btnadd.layer.cornerRadius = 10
                btnadd.tag = indexPath.row
                btnadd.addTarget(self, action: #selector(btnAddPress), for: UIControl.Event.touchUpInside)
                cell.addSubview(btnadd)
        
                let lblPrice = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-50, y: 10, width: 50, height: 20))
                lblPrice.text = dictTest["prize"]![indexPath.row] as! String
                cell.addSubview(lblPrice)
        
        }
        
        return cell
    }
    
    
    @objc func btnSubstractPress(sender:UIButton){
        let tmpvalue =  dictTest["quantity"]![sender.tag] as! Int
        
       total = 0
        if tmpvalue == 1{

             dictTest["quantity"]?.remove(at: sender.tag)
            dictTest["prize"]?.remove(at: sender.tag)
            dictTest["menuList"]?.remove(at: sender.tag)
            dictTest["listNo"]?.remove(at: sender.tag)
            print(dictTest["quantity"]?.count)
            print("final data is \(dictTest)")
             tblCart.reloadData()
        }
        if tmpvalue>1{
        
            dictTest["quantity"]![sender.tag] = tmpvalue - 1
        
            let tmpprice =  dictTest["prize"]![sender.tag] as! String
            let editedText = tmpprice.replacingOccurrences(of: "$", with: "")
            let temp2 = Int(editedText)
        
            let temp3 = temp2!/(tmpvalue)
            let tmp4 = temp3 * (tmpvalue - 1)
        
        
        
            let strtmp = "$\(tmp4)"
            print(strtmp)
        
            dictTest["prize"]![sender.tag] = strtmp
        
            tblCart.reloadData()
        }
        amountCalculate()
        
    }
    @objc func btnAddPress(sender:UIButton){
        
        total = 0
        
        let tmpvalue =  dictTest["quantity"]![sender.tag] as! Int
        dictTest["quantity"]![sender.tag] = tmpvalue + 1
 
        let tmpprice =  dictTest["prize"]![sender.tag] as! String
        let editedText = tmpprice.replacingOccurrences(of: "$", with: "")
        let temp2 = Int(editedText)
        
        let temp3 = temp2!/(tmpvalue)
        let tmp4 = temp3 * (tmpvalue + 1)
        
        
        
        let strtmp = "$\(tmp4)"
        print(strtmp)
        
        dictTest["prize"]![sender.tag] = strtmp
        
        tblCart.reloadData()
        
        amountCalculate()
    }
    
    func amountCalculate() {
//        dictTest["prize"]
        for arr in dictTest["prize"] ?? [0] {
            let tmpprice =  arr as! String
            var tmp = tmpprice.replacingOccurrences(of: "$", with: "")
            let temp2 = Int(tmp)
            total = total + temp2!
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

}