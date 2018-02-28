//
//  ALKit.swift
//  Alamofire
//
//  Created by Aravind on 26/02/18.
//

import UIKit

typealias ALCompletionBlock = (_ address: Address, _ error: NSError) -> Void



public class ALKitView: UIViewController {
    @IBOutlet weak var btnResend: UIBarButtonItem!
    var flag = true {
        didSet {
             btnResend.isEnabled = !flag
            if flag {
                self.changeText(forObject: lblTitle, text: "Enter registered Email/ Mobile no to login")
                self.changeText(forObject: txtName, text: "Enter here...")
                self.changeText(forObject: btnLogin, text: "Send OTP")
                self.btnLogin.isEnabled = true
                self.activity.stopAnimating()
            } else {
                self.changeText(forObject: lblTitle, text: "Enter OTP sent to your registered mobile number.")
                self.changeText(forObject: txtName, text: "Enter OTP...")
                self.changeText(forObject: btnLogin, text: "Login")
                txtName.text = ""
                self.btnLogin.isEnabled = true
            } } }

    var completionHandler: ((_ childVC: ALKitView) -> Void)?
    weak open var delegate: ALKitDelegate?
    weak open var titleColor: UIColor?
    weak open var topColor: UIColor?
    weak open var statusBarColor: UIColor?
    var mailID: String!
    var otp: String!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    var addressList: Array<NSDictionary>! {
        didSet {
            table.isHidden = false
            table.dataSource = self
            table.delegate = self
            table.reloadData()
        }
    }
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtotp: UITextField!

    override public func viewDidLoad() {
        super.viewDidLoad()
        activity.stopAnimating()
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.white
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        flag = true
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.table.isHidden = true
         flag = true
    }
    
    @IBAction func onCancel(_ sender: Any) {self.dismiss(animated: true, completion: nil)  }

    @IBAction func begin(_ sender: Any) {
        let btn = sender as! UIButton
        if btn.title(for: .normal) == "Send OTP"//Anim
            {
            flag = false
        } else {
            flag = true
            DispatchQueue.main.async {
                self.activity.startAnimating()
                /*ALWebManager.sharedInstance.performTask(strURL: "url", method: "POST", headers:nil, parameters: nil, onSuccess: { (dictResponse) in
                 self.delegate?.didALKitCompleteLogin(JSON: dictResponse as NSDictionary)
                 }, onFailure: { (Err) in
                 self.delegate?.didALKitFailedWithError(Error: Err)
                 print(Err)
                 })*/

                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0)
                {
                    // self.gameOver(NSDictionary())
                    self.beginGame()
                }
            }
        }
    }
}

extension ALKitView
{
    fileprivate func changeText(forObject Object: AnyObject, text: String) {
        let anim = CATransition()
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.type = kCATransitionFade
        anim.duration = 0.50
        Object.layer.add(anim, forKey: "kCATransitionFade")
        if Object.isKind(of: UITextField.self) {
            let obj = Object as! UITextField
            obj.placeholder = text
        }
        if Object.isKind(of: UILabel.self) {
            let obj = Object as! UILabel
            obj.text = text
        }
        if Object.isKind(of: UIButton.self) {
            let obj = Object as! UIButton
            obj.setTitle(text, for: .normal)
        }
    }

    fileprivate func makeAddress(_ dict: NSDictionary) -> Address
    {
        let address = Address()
        for (key, value) in dict
        {
            if key as! String == "error" { address.error = NSError(domain: value as! String, code: (value as! NSString).integerValue, userInfo: nil) }
            if key as! String == "key" { address.key = value as? String }
            if key as! String == "zip" { address.zip = value as? String }
            if key as! String == "userid" { address.userID = value as? String }
        }
        return address
    }
}

extension ALKitView: UITableViewDataSource, UITableViewDelegate
{
    fileprivate func beginGame()
    {
        //#
        let dict = NSMutableDictionary()
        dict.setValue("sdfehuy67efjkhfiuyhrjk8786jkniufr", forKey: "key")
        dict.setValue("Lexy Pandera", forKey: "name")
        dict.setValue("568265", forKey: "zip")
         dict.setValue("AD45V", forKey: "id")
        
        self.txtName.text = ""
        self.view.endEditing(true)
        self.lblTitle.text = "Select address"
        self.addressList = [dict, dict, dict,dict, dict, dict,dict, dict, dict]

        /*ALWebManager.sharedInstance.getAllAddressForUser(userID: " ", onSuccess: { (dict) in
            self.addressList = dict["code"] as! Array<NSDictionary>
        }) { (Err) in
            self.delegate?.didALKitFailedWithError(Error: Err as NSError)
        }*/
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return addressList.count }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { self.delegate?.didSelectAddress(addresss: self.makeAddress(self.addressList[indexPath.row])) } }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.addressList[indexPath.row].value(forKey: "name") as! String
        cell.detailTextLabel?.text = self.addressList[indexPath.row].value(forKey: "id") as! String
        return cell
    }

}
