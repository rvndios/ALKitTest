//
//  ALKitDelegate.swift
//  ALKit
//
//  Created by Aravind on 27/02/18.
//

import Foundation

public protocol ALKitDelegate: NSObjectProtocol
{
    func didALKitCompleteLogin(_ json: NSDictionary)
    func didALKitFailedWithError(_ json: NSDictionary)
}

public protocol ALDelegate: NSObjectProtocol
{
    func aLKitCompleteLogin(JSON: NSDictionary)
    func aLKitFailedWithError(JSON: NSDictionary)
}
