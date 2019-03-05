//
//  MainViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 19/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var serchBarview: UISearchBar!
    
     var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    
//    let cellReuseIdentifier = "cell"
    private let cellReuseIdentifier: String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictTest["price"] = []
        dictTest["listNo"] = []
        dictTest["quantity"] = []
        dictTest["menuList"] = []
        dictTest["restID"] = []

        // Do any additional setup after loading the view.
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblView.delegate = (self as UITableViewDelegate)
        tblView.dataSource = (self as UITableViewDataSource)
        
        self.navigationController?.isNavigationBarHidden = true
        
        serchBarview.delegate = self
        
        //"http://192.168.1.5:8080/api/restaurant/list"
        Alamofire.request(apirestaurantList ).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let resData = swiftyJsonVar.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    
                    print("data is as follow \(self.arrRes) \(self.arrRes.count)")
                }
                if self.arrRes.count>0{
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    
    
    //MARK: TableView Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")

        var dict = arrRes[indexPath.row]
        
        let imgHotel = UIImageView(frame: CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width-40, height: 170) )
        var imageUrlString = dict["resturantImage"]as! String
        imageUrlString =  GVImageBaseURL + imageUrlString
        let imageUrl:URL = URL(string: imageUrlString)!
        // Start background thread so that image loading does not make app unresponsive
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                imgHotel.image = image
                imgHotel.contentMode = UIView.ContentMode.scaleAspectFit
                
            }
        }
        
        cell.addSubview(imgHotel)
        
        let tmpView = UIView(frame: CGRect(x: 20, y: 175, width: UIScreen.main.bounds.size.width-40, height: 75))
        tmpView.backgroundColor = UIColor.white
        cell.addSubview(tmpView)
        
        let lblHotelName = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: 30))
        lblHotelName.backgroundColor = UIColor.white
        lblHotelName.text = dict["resturantName"] as? String
        lblHotelName.textColor = UIColor.gray
        lblHotelName.font = lblHotelName.font.withSize(20)
        tmpView.addSubview(lblHotelName)
        
        let lblHoteldesc = UILabel(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.size.width-40, height: 20))
        lblHoteldesc.text = dict["resturantCuisine"] as? String
        lblHoteldesc.textColor = UIColor.gray
        lblHoteldesc.font = lblHotelName.font.withSize(12)
        tmpView.addSubview(lblHoteldesc)
        
        return cell
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250.0;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         var dict = arrRes[indexPath.row]
//        tblView.backgroundColor = UIColor.clear
        let displayVC : MenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        displayVC.ddata = "Next level blog photo booth, tousled authentic tote bag kogi"
        resturantId = dict["resturantId"] as! Int
        self.present(displayVC, animated: true, completion: nil)
    }
    
    

}

//MARK: Extension UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
}
