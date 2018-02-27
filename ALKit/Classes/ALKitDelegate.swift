//
//  ALKitDelegate.swift
//  ALKit
//
//  Created by Aravind on 27/02/18.
//

import Foundation

public protocol ALKitDelegate: NSObjectProtocol
{
    func didALKitCompleteLogin(JSON: NSDictionary)
    func didALKitFailedWithError(Error: NSError)
    func didSelectAddress(addresss: Address)
    func didUserCanceled()
}
