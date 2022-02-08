//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class MyAPIClient: NSObject, STPEphemeralKeyProvider {

    static let sharedClient = MyAPIClient()
    var baseURLString: String? = GVBaseURL + "stripe/"
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }

    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result<Any>) -> Void) {
        // 1
        let url = baseURL.appendingPathComponent("charge/")
        // 2
        print(token.tokenId)
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": stripeTotal * 100,
            "currency": "usd",
            "description": "Purchase for order \(orderIDis)"
            
        ]
        
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success:
                    completion(Result.success(response.result))
                    print("stripe standerd is \(response.result)")
                case .failure(let error):
                    completion(Result.failure(error))
                    print("stripe standerd is \(error)")
                }
        }
    }
    
    
    

    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

}


//second test edit
