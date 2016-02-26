//
//  AppDelegate.swift
//  Starck Control
//
//  Created by Chris Kurzeja on 07/10/2015.
//  Copyright © 2015 Chris Kurzeja. All rights reserved.
//

import Cocoa
import IOBluetooth

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var connection : BluetoothConnection?
    var deviceConnectionListener: BluetoothDeviceConnectionListener?
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        print("application did finish loading")
        if let button = statusItem.button {
            print("button was found")
            button.image = NSImage(named: "Icon")
        }
        
        foo();
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Parrot Zik 2.0 Controls", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Close Starck Control", action: Selector("terminate:"), keyEquivalent: ""))
        statusItem.menu = menu
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        if let listener = deviceConnectionListener {
            listener.stopListening()
        }
        if let connection = self.connection {

        }
    }
    
    func foo() {
        if let macAddress = MACFinder().getMACForZiks() {
            print("found mac for zik")
            connection = BluetoothConnection(macAddress: macAddress)
            deviceConnectionListener = BluetoothDeviceConnectionListener(device: connection!.device)
//            deviceConnectionListener!.startListening()
        }
    }
    
}


