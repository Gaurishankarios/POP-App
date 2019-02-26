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
                    print(value.dictionaryValue)
                    print("result is \(result)")
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    UserDefaults.standard.set(true, forKey: "userlogin")
                    
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

