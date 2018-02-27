//
//  ViewController.swift
//  ALKit
//
//  Created by rvndios on 02/26/2018.
//  Copyright (c) 2018 rvndios. All rights reserved.
//

import UIKit
import ALKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc @IBAction func login()
    {
       // let mgr = ALLoginManager(appID: "appidvalue435")
        let manager = ALLoginManager.shared
        manager.delegate = self
        manager.logIn(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController : ALKitDelegate
{
    func alert(title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (ac) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didSelectAddress(addresss: Address)
    {
        let alert = UIAlertController.init(title: "Address Selected!", message: "Details: \(addresss.zip!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (ac) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didALKitCompleteLogin(JSON: NSDictionary) {
        let alert = UIAlertController.init(title: "Done!", message: "Login Sucess: \(String(describing: JSON.value(forKey: "key")))", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (ac) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didALKitFailedWithError(Error: NSError) {
        
    }
    
    func didUserCanceled(){
        self.alert(title: "Oops!", message: "User Canceled")
    }
}


