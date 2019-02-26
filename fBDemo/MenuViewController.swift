//
//  MenuViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 25/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var scrollViewBtn: UIScrollView!
    var buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        UIJscrollBtn()
    }
    
    func UIJscrollBtn(){
        for i in 0...5{
           
            let button = UIButton()
            button.tag = i
            button.backgroundColor = UIColor.darkGray
            button.setTitle("\(i)", for: .normal)
            button.addTarget(self, action: #selector(btnTouch), for: UIControl.Event.touchUpInside)
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 70, height: 30)
            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            scrollViewBtn.addSubview(button)
            
        }
        scrollViewBtn.contentSize = CGSize(width: xOffset, height: scrollViewBtn.frame.height)
        
    }
    
    @objc func btnTouch(){
//        if button.tag == 0{
//            print("button 0 press")
//        }else if button.tag == 1{
//            print("button 1 press")
//        }
    }

   

}
