    //
    //  ViewController.swift
    //  fBDemo
    //
    //  Created by Parvez Shaikh on 18/02/19.
    //  Copyright © 2019 Parvez Shaikh. All rights reserved.
    //

    import UIKit
    import FacebookLogin
    import FacebookCore
    import Firebase
    import GoogleSignIn
    import Alamofire
    import SwiftyJSON
    

    class ViewController: UIViewController,LoginButtonDelegate, GIDSignInUIDelegate {

         @IBOutlet weak var signInButton: GIDSignInButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
     
            //Default
    //        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
    //
    //        loginButton.center = view.center
    //        loginButton.delegate = self
    //        view.addSubview(loginButton)
            
//            let status = UserDefaults.standard.bool(forKey: "userlogin") ?? false
//            
//            if status{
//                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
//                self.navigationController?.pushViewController(vc!, animated: true)
//            }
            
            //custom button
            let loginButton = LoginButton(readPermissions: [.publicProfile,.email])
            loginButton.frame = CGRect(x: 20, y: view.frame.height/2+50, width: view.frame.width - 40, height: 50)
            loginButton.delegate = self
            view.addSubview(loginButton)
            
            if let accessToken = AccessToken.current {
                getFBUserInfo()
            }
            
            
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            
            
            
            
            
        }
        
        // MARK: get user data
        func getFBUserInfo() {
            let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
            request.start { (response, result) in
                switch result {
                case .success(let value):
                    print(value.dictionaryValue!["name"]!)
                    print("result is \(result)")
                    
                    let url = "http://182.73.184.62:443/api/login/save" // This will be your link
                    let parameters: Parameters = ["userEmailId": value.dictionaryValue!["email"]!, "deviceToken": fcmdeviceToken, "userName": value.dictionaryValue!["name"]!, "userRole": "user", "loginStatus": "true" ]      //This will be your parameter
                    print("\(parameters)")
                    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                        print(response)

                        let swiftyJsonVar = JSON(response.result.value!)
                        print("server data is  \(swiftyJsonVar)")
                        
                        
                        if let name = swiftyJsonVar["userId"].string {
                            // get name
                            
                            UserDefaults.standard.set(true, forKey: "userlogin")
                            //                            UserDefaults.standard.set(name, forKey: "userId")
                            UserDefaults.standard.set(name, forKey: "userId")
                            userIDofuser = Int(name)!
                            
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                           
                        }
                            
                    }
                    
                   
                    
                case .failed(let error):
                    print(error)
                }
            }
        }
        // MARK: LoginButtonDelegate method
        func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
            print("logged in")
            self.getFBUserInfo()
        }
        
        func loginButtonDidLogOut(_ loginButton: LoginButton) {
            print("logged out")
        }
        
        

    }

