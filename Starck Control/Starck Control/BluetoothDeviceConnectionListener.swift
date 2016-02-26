//
//  BluetoothDeviceConnectionListener.swift
//  Starck Control
//
//  Created by Chris Kurzeja on 19/09/2015.
//  Copyright (c) 2015 Chris Kurzeja. All rights reserved.
//

import Foundation
import IOBluetooth



class BluetoothDeviceConnectionListener : NSObject {
    
    let device: IOBluetoothDevice
    var inRefCon = UnsafeMutablePointer<Void>.alloc(1)
    var connectNotification: IOBluetoothUserNotificationRef?
    var disconnectNotification: IOBluetoothUserNotification!
    
    init(device: IOBluetoothDevice) {
        self.device = device
       self.startListening()
    }

    
    deinit {
        stopListening()
    }
    
    func connectedUpdate(notification: IOBluetoothUserNotificationRef, ref: IOBluetoothObjectRef) {
        print(self.connectNotification)
        print(notification)
        print(self.connectNotification === notification)
        if (self.connectNotification === notification) {
            print("connect")
            IOBluetoothUserNotificationUnregister(notification)
            connectNotification = nil
            
            disconnectNotification = device.registerForDisconnectNotification(self, selector: "deviceDisconnect")
        }
    }
    
    func deviceDisconnect() {
        print("disconnect")
        disconnectNotification.unregister()
//        inRefCon = toPointer(self)
//                connectNotification = IOBluetoothRegisterForDeviceConnectNotifications(callback, inRefCon).takeUnretainedValue()
        startListening()
    }
    
    
    func startListening() {
        inRefCon = toPointer(self)
        connectNotification = IOBluetoothRegisterForDeviceConnectNotifications(callback, inRefCon).takeUnretainedValue()
    }
    
    func stopListening() {
        if let notification = connectNotification {
            IOBluetoothUserNotificationUnregister(notification)
        }
    }


    let callback : IOBluetoothUserNotificationCallback =
    { (userRefCon, inRef, status) in
        let mySelf : BluetoothDeviceConnectionListener = bridge(userRefCon)
        mySelf.connectedUpdate(inRef, ref: status)
    }
    
}

func toPointer<T : AnyObject>(obj : T) -> UnsafeMutablePointer<Void> {
    return UnsafeMutablePointer(Unmanaged.passUnretained(obj).toOpaque())
    // return unsafeAddressOf(obj) // ***
}

func bridge<T : AnyObject>(ptr : UnsafeMutablePointer<Void>) -> T {
    return Unmanaged<T>.fromOpaque(COpaquePointer(ptr)).takeUnretainedValue()
    // return unsafeBitCast(ptr, T.self) // ***
}
