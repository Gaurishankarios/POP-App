//
//  CartViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 28/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var tblCart: UITableView!
    
    let arrMenulist = dictTest["menuList"]
    let arrquantity = dictTest["quantity"]
    let arrprize = dictTest["prize"]
    let arrlistNo = dictTest["listNo"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("cart data is \(dictTest)")
        
//        tblCart.delegate = self
//        tblCart.dataSource = self
        // Do any additional setup after loading the view.
        
       
        
        print("arrquantity is \(String(describing: arrquantity))")
        print("menuList is \(String(describing: arrMenulist))")
        print("arrprize is \(String(describing: arrprize))")
        print("arrlistNo is \(String(describing: arrlistNo)) \(arrlistNo?.count)")
        
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
