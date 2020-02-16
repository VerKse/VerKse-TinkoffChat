//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vera on 16.02.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        super.viewDidAppear(false)
        super.viewWillLayoutSubviews()
        super.viewDidLayoutSubviews()
        super.viewDidAppear(false)
        super.viewWillDisappear(false)
        super.viewDidDisappear(false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from DISAPPEARED/DISAPPEARING to APPEARING : viewWillAppear")
        }
    }
    
    override func viewWillLayoutSubviews() {
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application is about to layout its subviews: viewWillLayoutSubviews")
        }
    }
    
    override func viewDidLayoutSubviews() {
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application has just laid out its subviews: viewDidLayoutSubviews")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from APPEARING to APPEARED: viewDidAppear")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from APPEARED/APPEARING to DISAPPEARING: viewWillDisappear")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (ProcessInfo.processInfo.environment["UIVC_LIFESYCLE_LOGS"] == "consolePrint") {
            print("Application moved from DISAPPEARING to DISAPPEAR: viewDidDisappear")
        }
    }
}

