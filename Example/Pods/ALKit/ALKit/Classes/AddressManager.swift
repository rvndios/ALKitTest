//
//  ALLoginManager.swift
//  Alamofire
//
//  Created by Aravind on 27/02/18.
//

import Foundation

public enum ALStyleType: Int
{
    case light = 1
    case dark = 2
}

public final class AddressManager
{
    let alDarkBg : UIColor = .lightGray
    let altitleClr : UIColor = .white
    
    open var backGroundColor: UIColor = UIColor.white
    open var titleColor: UIColor = UIColor.white
    open var navigationBarColor: UIColor = UIColor.init(red: 57 / 255, green: 99 / 255, blue: 150 / 255, alpha: 1.0)
    open var statusBarColor: UIColor = UIColor.init(red: 57 / 255, green: 99 / 255, blue: 150 / 255, alpha: 1.0)
    
    
    internal var loginKit: ALKitView!
    static let APPID_MISSING: String = "App ID is not found. Add ADDRESS_APPID in your app info.plist."
    static let ADDRESS_APPID: String = "ADDRESS_APPID"
    weak open var delegate: ALKitDelegate?
    private var alAppid: String!
    
    internal init() { }
    
    internal init(alAppid: String) {
        self.alAppid = alAppid
    }
}



extension  AddressManager
{
    @available(*, deprecated: 10.0, message: "ALLoginManager is not supported on below iOS 10.0")
    public static var shared: AddressManager =
        {
            if let id = Bundle.main.object(forInfoDictionaryKey: ADDRESS_APPID) { } else {
                fatalError(APPID_MISSING)
            }
            return AddressManager(alAppid: Bundle.main.object(forInfoDictionaryKey: ADDRESS_APPID)! as! String)
    }()

    public convenience init(alAppid: String, style: ALStyleType) {
        self.init()
        self.alAppid = alAppid
        loginKit = (UIStoryboard (name: "ALKit", bundle: Bundle(for: ALKitView.self))).instantiateViewController(withIdentifier: "ALKitView") as! ALKitView
        loginKit.view.backgroundColor = backGroundColor
        loginKit.titleColor = titleColor
        loginKit.topColor = navigationBarColor
        if style.rawValue == 2 {
            loginKit.view.backgroundColor = self.alDarkBg
            loginKit.titleColor = self.altitleClr
            loginKit.topColor = navigationBarColor
            loginKit.statusBarColor = statusBarColor
        }
        loginKit.modalPresentationStyle = .overFullScreen
    }
}

extension AddressManager
{
    public func logIn(viewController: UIViewController? = nil)
    {
        loginInit()
        loginKit.delegate = (viewController as! ALKitDelegate)
        if viewController == nil {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                loginKit.delegate = (topController as! ALKitDelegate)
                topController.present(loginKit, animated: true, completion: nil)
            }
        } else {
            viewController?.present(loginKit, animated: true, completion: nil)
        }
    }
    
    fileprivate func loginInit() {
        loginKit = (UIStoryboard (name: "ALKit", bundle: Bundle(for: ALKitView.self))).instantiateViewController(withIdentifier: "ALKitView") as! ALKitView
        loginKit.view.backgroundColor = backGroundColor
        loginKit.titleColor = titleColor
        loginKit.topColor = navigationBarColor
        loginKit.modalPresentationStyle = .overFullScreen
        loginKit.statusBarColor = statusBarColor
        loginKit.modalPresentationStyle = .overFullScreen
    }
  
}

extension AddressManager {

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


