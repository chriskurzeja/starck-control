//
//  BluetoothConnection.swift
//  Starck Control
//
//  Created by Chris Kurzeja on 17/09/2015.
//  Copyright (c) 2015 Chris Kurzeja. All rights reserved.
//

import Foundation
import IOBluetooth

class BluetoothConnection : IOBluetoothRFCOMMChannelDelegate {
    
    let serviceName = "Parrot RFcomm service"
    let device: IOBluetoothDevice
    var rfCommChannel: IOBluetoothRFCOMMChannel?
    var inRefCon: UnsafeMutablePointer<Void> = UnsafeMutablePointer.alloc(1)
    
    init(macAddress: String) {
        device = IOBluetoothDevice(addressString: macAddress)
    }
    
    func foo() {
        for service in device.services {
            if let record = service as? IOBluetoothSDPServiceRecord {
                if let name = record.attributes[256]?.getStringValue() {
                    if (serviceName == name) {
                        
                        device.openRFCOMMChannelSync(&rfCommChannel, withChannelID: getChannel(record), delegate: self)
                        print("connection opened")
                        return
                    }
                }
            }
        }
    }
    
    
    func getChannel(service: IOBluetoothSDPServiceRecord) -> BluetoothRFCOMMChannelID {
        let channelPtr: UnsafeMutablePointer<BluetoothRFCOMMChannelID> = UnsafeMutablePointer.alloc(1)
        service.getRFCOMMChannelID(channelPtr)
        return channelPtr.move()
    }
    
    func rfcommChannelData(rfcommChannel: IOBluetoothRFCOMMChannel!, data dataPointer: UnsafeMutablePointer<Void>, length dataLength: Int) {
        print("data received")
    }
    
}
