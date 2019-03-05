//
//  ShowQRViewController.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 04/03/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import UIKit

class ShowQRViewController: UIViewController {

    @IBOutlet weak var imgQRCode: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let image = generateQRCode(from: "your data is \(dictTest)")
        imgQRCode.image = image
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
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
