//
//  ViewController.swift
//  RADAttribution
//
//  Created by Andrii Durbalo on 03/31/2020.
//  Copyright (c) 2020 Andrii Durbalo. All rights reserved.
//

import UIKit
import RADAttribution

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resolveLinkUniversalButtonPressed(_ sender: Any) {
        
        let appToAppUniversalLink = "https://rakutenready.app.link/ui3knDTZH0?%243p=a_rakuten_marketing%24s2s=true"
        
        RADAttribution.shared.linkResolver.resolve(link: appToAppUniversalLink)
    }
    
    @IBAction func resolveLinkBranchButtonPressed(_ sender: Any) {
        
        let appToAppBranchLink = "https://rakutenready.app.link/SRzsoXecN0"
         RADAttribution.shared.linkResolver.resolve(link: appToAppBranchLink)
    }
    
    @IBAction func sendEventButtonPressed(_ sender: Any) {
        
        RADAttribution.shared.eventTracker.sendEvent(name: "TEST_EVENT")
    }
}

