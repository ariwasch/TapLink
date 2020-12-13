//
//  UsePage.swift
//  TapShare2
//
//  Created by Ari Wasch on 10/14/20.
//

import Foundation
import UIKit

class UsePage: UIViewController{

    var view1: ViewController = ViewController()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func `continue`(_ sender: Any) {
        defaults.set("finished", forKey: "start")
    }
}
