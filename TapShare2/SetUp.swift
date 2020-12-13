//
//  SetUp.swift
//  TapShare2
//
//  Created by Ari Wasch on 10/13/20.
//

import Foundation
import UIKit

class SetUp: UIViewController{
    let defaults = UserDefaults.standard

    @IBOutlet weak var textBoi: UITextView!
    var view1: ViewController = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        print(view1.done)
//    }
    @IBAction func clear(_ sender: Any) {
        textBoi.text = ""
    }
    @IBAction func save(_ sender: Any) {
        if(textBoi.text != "" && !textBoi.text.contains(" ")){
            var link = ""
            if(textBoi.text.contains("http")){
                link = textBoi.text ?? "ERROR"
            }else if(textBoi.text.contains("www")){
                link = "http://" + textBoi.text
                view1.startWrite(m: "http://" + textBoi.text)
            }else{
                link = "http://www." + textBoi.text
            }
            print("ASODIJIOASJDIOAS")

            defaults.set(link, forKey: "link")
            print(link)
            self.textBoi.text = ""
            
        }
    }
    @IBAction func write(_ sender: Any) {
        if(textBoi.text != ""){
            var link = ""
            if(textBoi.text.contains("http")){
                link = textBoi.text ?? "ERROR"
                print("httpwww")

            }else if(textBoi.text.contains("www")){
                link = "http://" + textBoi.text
                view1.startWrite(m: "http://" + textBoi.text)
                print("www")
            }else{
                print("ppopp")

                link = "http://www." + textBoi.text
            }
            defaults.set(link, forKey: "link")
            print(link)
            self.textBoi.text = ""
            
            view1.startWrite(m: link)


//            textBoi.text = ""

        }
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

