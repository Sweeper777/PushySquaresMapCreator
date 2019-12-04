//
//  AppDelegate.swift
//  PushySquaresMapCreator
//
//  Created by Mulang Su on 23/11/2019.
//  Copyright © 2019 Mulang Su. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.set(false, forKey: "NSFullScreenMenuItemEverywhere")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

