//
//  ALLoginManager.swift
//  Alamofire
//
//  Created by Aravind on 27/02/18.
//

import Foundation

public enum ALStyleType : Int
{
    case light = 1
    case dark = 2
}


public final class AddressManager
{
    open var  backGroundColor : UIColor = UIColor.white
    open var  titleColor : UIColor = UIColor.white
    open var  navigationBarColor : UIColor = UIColor.init(red: 57/255, green: 99/255, blue: 150/255, alpha: 1.0)
    open var  statusBarColor : UIColor = UIColor.init(red: 57/255, green: 99/255, blue: 150/255, alpha: 1.0)
    
    
    internal var loginKit: ALKitView!
    static let APPID_MISSING : String = "App ID is not found. Add ADDRESS_APPID in your app info.plist."
    static let ADDRESS_APPID : String = "ADDRESS_APPID"
     weak open var delegate: ALKitDelegate?
    private var appID : String!
    
    @available(*, deprecated: 10.0, message: "ALLoginManager is not supported on below iOS 10.0")
    public static var shared: AddressManager =
    {
        if let id = Bundle.main.object(forInfoDictionaryKey: ADDRESS_APPID){}else{
            fatalError(APPID_MISSING)
        }
        return  AddressManager(appID: Bundle.main.object(forInfoDictionaryKey: ADDRESS_APPID)! as! String)
    }()
    
    internal init(){ }
    
    public convenience init(appID: String, style: ALStyleType){
        self.init()
        self.appID = appID
        loginKit = (UIStoryboard (name: "ALKit", bundle: Bundle(for: ALKitView.self))).instantiateViewController(withIdentifier: "ALKitView") as! ALKitView
        loginKit.view.backgroundColor = backGroundColor
        loginKit.titleColor = titleColor
        loginKit.topColor = navigationBarColor
        if style.rawValue == 2{
            loginKit.view.backgroundColor = .lightGray
            loginKit.titleColor = .white
            loginKit.topColor = navigationBarColor
            loginKit.statusBarColor = statusBarColor
        }
        loginKit.modalPresentationStyle = .overFullScreen
    }
    
    internal init(appID: String){
        self.appID = appID
        loginKit = (UIStoryboard (name: "ALKit", bundle: Bundle(for: ALKitView.self))).instantiateViewController(withIdentifier: "ALKitView") as! ALKitView
        loginKit.view.backgroundColor = backGroundColor
        loginKit.titleColor = titleColor
        loginKit.topColor = navigationBarColor
        loginKit.modalPresentationStyle = .overFullScreen
        loginKit.statusBarColor = statusBarColor
    }
    
    public func logIn(viewController: UIViewController? = nil)
    { self.login()}
}

extension AddressManager
{
    fileprivate func login(viewController: UIViewController? = nil){
        if viewController == nil{}else{
           viewController?.present(loginKit, animated: true, completion: nil)
        }
    }
}

extension AddressManager{
    
    public func saveUserTocken(_ tocken: String)
    {
        let kcw = ALUserManager.init(serviceName: "AddressCode")
        kcw.set(tocken, forKey: "alUserTocken")
    }
    
    public func getUserTocken() -> String
    {
        let kcw = ALUserManager.init(serviceName: "AddressCode")
        return kcw.string(forKey: "alUserTocken")!
    }
    
    public func debugFatalError(_ message: String) {
        #if DEBUG
            fatalError(message)
        #else
            print(message)
        #endif
    }
}


