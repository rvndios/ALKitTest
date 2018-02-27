//
//  ALLoginManager.swift
//  Alamofire
//
//  Created by Aravind on 27/02/18.
//

import Foundation

public final class ALLoginManager
{
    static let APPID_MISSING : String = "App ID is not found. Add ADDRESS_APPID in your app info.plist."
    static let ADDRESS_APPID : String = "ADDRESS_APPID"
     weak open var delegate: ALKitDelegate?
    private var appID : String!
    
    public static var shared: ALLoginManager =
    {
        if let id = Bundle.main.object(forInfoDictionaryKey: ADDRESS_APPID){}else{
            fatalError(APPID_MISSING)
        }
        return  ALLoginManager(appID: Bundle.main.object(forInfoDictionaryKey: ADDRESS_APPID)! as! String)
    }()
    
    internal init(appID: String){
        self.appID = appID
    }
}

extension ALLoginManager
{
    public func logIn(viewController: UIViewController? = nil)
    {
        let vc = (UIStoryboard (name: "ALKit", bundle: Bundle(for: ALKitView.self))).instantiateViewController(withIdentifier: "ALKitView") as! ALKitView
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = viewController as? ALKitDelegate
        viewController?.present(vc, animated: true, completion: { })
    }
}

extension ALLoginManager{
    
    public func debugFatalError(_ message: String) {
        #if DEBUG
            fatalError(message)
        #else
            print(message)
        #endif
    }
}


