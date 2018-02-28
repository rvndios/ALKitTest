//
//  ALWebManager.swift
//  ALKit
//
//  Created by Aravind on 27/02/18.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]
enum Errors: Int {
    case appIDNotFound = -1
    case timeout = -2
    case invalidState = -3
    case notFound = 404
    case unknown
    
    init(value: Int) {
        if let error = Errors(rawValue: value) {
            self = error
        } else {
            self = .unknown
        }
    }
}

class ALWebManager
{
    private let baseURL = "https://address.co"
    static let sharedInstance = ALWebManager()
    
    public func verifyLogin(mailID: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url = baseURL + "/verifylogin"
        let method = "POST"
        let header = addTockenHeaders(token: "token")
        let parameter : Parameters? = ["tocken" : mailID as Any]
        
        self.performTask(strURL: url, method: method, headers: header, parameters: parameter, onSuccess: { (dict) in
            
        }) { (Err) in
        }
    }
    
    public func performSendOtp(mailID: String, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url = baseURL + "/sendotp"
        let method = "POST"
        let header = addTockenHeaders(token: "token")
        let parameter : Parameters? = ["mailid" : mailID as Any]
        
        self.performTask(strURL: url, method: method, headers: header, parameters: parameter, onSuccess: { (dict) in
            
        }) { (Err) in
        }
    }

    public func performLogin(otp: String,onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url = baseURL + "/login"
        let method = "POST"
        let header = addTockenHeaders(token: "token")
        let parameter : Parameters? = ["otp" : otp as Any]
        
        self.performTask(strURL: url, method: method, headers: header, parameters: parameter, onSuccess: { (dict) in
            ALUserManager.standard.saveUserTocken(dict["key"]! as! String)
        }) { (Err) in
            
        }
    }
    
    public func getAllAddressForUser(userID: String,onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url = baseURL + "/codes"
        let method = "POST"
        let header = addTockenHeaders(token: "token")
        let parameter : Parameters? = ["userID" : userID as Any]
        
        self.performTask(strURL: url, method: method, headers: header, parameters: parameter, onSuccess: { (dict) in
            
        }) { (Err) in
            
        }
    }
    
    
    public func getAddressForID(addressID: String,onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url = baseURL + "/code"
        let method = "POST"
        let header = addTockenHeaders(token: "token")
        let parameter : Parameters? = ["addressID" : addressID as Any]
        
        self.performTask(strURL: url, method: method, headers: header, parameters: parameter, onSuccess: { (dict) in
            
        }) { (Err) in
        }
    }
}

extension ALWebManager{
    public func performTask(strURL: String, method: String,headers: HTTPHeaders? = nil, parameters: Parameters? = nil, onSuccess: @escaping([String: Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url: String = baseURL //strURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        if let postData = (try? JSONSerialization.data(withJSONObject: parameters as Any, options: [])) {
            request.httpBody = postData
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if(error != nil)
            {
                onFailure(error!)
            } else {
                do
                {
                    if let JSONObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any],
                        let dict = JSONObject as? [String: Any]{
                        onSuccess(dict)
                    }
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    internal func addTockenHeaders(token:String) -> HTTPHeaders{
        return ["Authentication" : "Bearer \(token)", "application/x-www-form-urlencoded": "Content-Type"]
    }
}
