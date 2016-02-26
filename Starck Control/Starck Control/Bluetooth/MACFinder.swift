//
//  MACFinder.swift
//  Starck Control
//
//  Created by Chris Kurzeja on 17/09/2015.
//  Copyright (c) 2015 Chris Kurzeja. All rights reserved.
//

import Foundation

class MACFinder {
    
    func getMACForZiks() -> String? {
        let bluetoothPlist = NSURL(fileURLWithPath: "/Library/Preferences/com.apple.Bluetooth.plist")
        let dictionary = NSDictionary(contentsOfURL: bluetoothPlist)
        
        
        if let devices = dictionary!.valueForKey("BRPairedDevices") as? [AnyObject] {
            for entry in devices {
                if let mac = entry as? String {
                    if let match = mac.uppercaseString.rangeOfString("A0-14-[0-9A-Fa-f]{2}-[0-9A-Fa-f]{2}-[0-9A-Fa-f]{2}-[0-9A-Fa-f]{2}", options: .RegularExpressionSearch) {
                        return mac
                    }
                }
            }
            
        }
        
        return nil
    }
}