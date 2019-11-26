//
//  ViewController.swift
//  PushySquaresMapCreator
//
//  Created by Mulang Su on 23/11/2019.
//  Copyright © 2019 Mulang Su. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var gameBoardView: GameBoardView!
    @IBOutlet var gameBoardTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

