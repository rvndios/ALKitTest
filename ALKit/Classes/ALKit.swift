//
//  ALKit.swift
//  Alamofire
//
//  Created by Aravind on 26/02/18.
//

import UIKit
import Alamofire


typealias ALCompletionBlock = (_ address: Address, _ error: NSError) -> Void
public protocol ALDelegate: NSObjectProtocol
{
    func ALFinishedLogin(_ json: NSDictionary)
}

public class ALKitView: UIViewController {
    
    var completionHandler : ((_ childVC:ALKitView) -> Void)?
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtotp: UITextField!
    weak var delegate: ALDelegate?
    weak open var delegates: ALDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        activity.stopAnimating()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSomething(_ strJSON: String)
    {
        DispatchQueue.main.async
            {
                self.btnLogin.isEnabled = true
                self.activity.stopAnimating()
                let data = strJSON.data(using: String.Encoding.utf8, allowLossyConversion: true)
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if ((dict.value(forKey: "error") as? NSNumber)?.boolValue)!
                    {
                        self.delegate?.ALFinishedLogin(dict.value(forKey: "data") as! NSDictionary)
                    } else {
                        self.delegate?.ALFinishedLogin(dict.value(forKey: "data") as! NSDictionary)
                    }
                } catch {
                    print(error)
                }
        }
    }
    
    fileprivate func gameOver()
    {
        self.btnLogin.isEnabled = true
        let dict = NSMutableDictionary()
        dict.setValue("sdfehuy67efjkhfiuyhrjk8786jkniufr", forKey: "key")
        dict.setValue("Pandera", forKey: "name")
        dict.setValue("AD45V", forKey: "id")
        
        // self.delegates?.ALFinishedLogin((dict as? NSDictionary)!)
        self.dismiss(animated: true) {
            self.delegates?.ALFinishedLogin((dict as? NSDictionary)!)
        }
        
        //        if let delegate = self.delegate {
        //            delegate.ALFinishedLogin(address: tmp)
        //        }
        //        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func begin(_ sender: Any) {
        self.btnLogin.isEnabled = false
        
        DispatchQueue.main.async {
            self.activity.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0)
            {
                self.gameOver()
            }
        }
    }
}

extension ALKitView
{
    fileprivate func makeAddress(_ dict: NSDictionary) -> Address
    {
        let address = Address()
        for (key, value) in dict
        {
            if key as! String == "error" { address.error = NSError(domain: value as! String, code: (value as! NSString).integerValue, userInfo: nil) }
            if key as! String == "hash" { address.key = value as? String }
            if key as! String == "username" { address.UserName = value as? String }
            if key as! String == "userid" { address.userID = value as? String }
        }
        return address
    }
    
    fileprivate func login(userName: String, password: String, completionHandler: @escaping ALCompletionBlock)
    {
        let request = NSMutableURLRequest()
        request.url = URL(string: "https:// url.com")
        request.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if (error != nil)
            {
                DispatchQueue.main.async {
                    let a = Address()
                    a.error = NSError(domain: "Error", code: -1, userInfo: nil)
                    completionHandler(a, a.error!)
                }
            } else {
                /*
                 let dict = try JSONSerialization.data(withJSONObject: data!, options: JSONSerialization.WritingOptions.prettyPrinted) as! NSDictionary
                 
                 if (dict.value(forKey: "Error") as? NSNumber).boolValue
                 {
                 let a = Address()
                 a.error = NSError(domain: dict.value(forKey: "reason"), code :-1, userInfo : nil)
                 completionHandler(a, a.error!)
                 }else
                 {
                 DispatchQueue.main.async {
                 let a = Address()
                 a.error = NSError(domain: "Login failed", code: -1, userInfo: nil)
                 completionHandler(a, a.error!)
                 }
                 }
                 */
            }
        }
        dataTask.resume()
    }
    
    
}
