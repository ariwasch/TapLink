//
//  Console.swift
//  NFC Digital Keypad
//
//  Created by Ari Wasch on 12/24/19.
//  Copyright © 2019 Ari Wasch. All rights reserved.
//

import Foundation
import CoreNFC
import UIKit
import GoogleMobileAds

class Console: UIViewController, ChartboostDelegate, CHBBannerDelegate {
    var session: NFCNDEFReaderSession?
    var view1: ViewController = ViewController()
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var textField: UITextField!
    let defaults = UserDefaults.standard
    var timer = Timer()
    var bannerView: GADBannerView!
    private lazy var banner = CHBBanner(size: CHBBannerSizeStandard, location: CBLocationDefault, delegate: self)
    private var logBeforeViewDidLoad = String()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        bannerView.adUnitID = bannerID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        addBannerViewToView(bannerView)
//        log(message: logBeforeViewDidLoad)
//        if banner.superview == nil {
//                    layoutBanner()
//                }
//        banner.show(from: self)

    }
    @IBAction func back(_ sender: Any) {
        if(textField.text != ""){
            view1.startWrite(m: textField.text ?? "ERROR")
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        var thing: String = ""
        print(view1.done)
        let key = defaults.string(forKey: "key")
        if(key == "true"){
        if let thingy = defaults.string(forKey: "record"){
            thing = thingy
        }
        if(thing != ""){
            textBox.text! += thing
            UserDefaults.standard.set("", forKey: "record")

            view1.recordText = ""

        }
            UserDefaults.standard.set("false", forKey: "key")

        }
            
            log(message: logBeforeViewDidLoad)
            if banner.superview == nil {
                        layoutBanner()
                    }
            banner.show(from: self)

        

    }
    @IBAction func clear(_ sender: Any) {
        textBox.text = ""
        textField.text = ""
    }
    @IBAction func read(_ sender: Any) {
        guard NFCReaderSession.readingAvailable else {
            return
        }
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near an NDEF tag to write the message."
        session?.begin()
    }

    @IBAction func send(_ sender: Any) {
//        ViewController.startWrite()
        if(textField.text != ""){
            view1.startWrite(m: textField.text ?? "ERROR")
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)

//            var i: Int = 0
//            while (view1.session?.alertMessage == "Hold your iPhone near an NDEF tag to write the message."){
////                i = i + 1
////                print(i)
////                if(i > 1000000){
////                    break
////                }
//            }
            
//            if(view1.done){
//                if(view1.result == "success"){
//            self.view.layoutIfNeeded()
//            if(view1.done){
//            if(view1.session?.alertMessage == "Write NDEF message successful."){
//                update(string: textField.text ?? "ERROR", type: "Write")
//
//            }else{
//                update(string: view1.session?.alertMessage ?? "error", type: "ERROR")
//
//            }
////                }else{
////                    update(string: view1.result , type: "Error")
////                }
////                view1.result = ""
////            }
//        }
        }
//        view1.done = false
//        view1.session?.alertMessage
    }
    @objc func updateTimer() {
        if(view1.done){
                    print("fkahfjfjasjofijai222222222222")
                    if(view1.session?.alertMessage == "Write NDEF message successful."){
                        update(string: view1.mess, type: "Write")
                        textField.text = ""
                    }else{
        //                update(string: view1.recordText ?? "error", type: "ERROR")
                    
                    }

                    view1.done = false
            timer.invalidate()
                }
    }
    //type = read or write
    func update(string: String, type: String){
        DispatchQueue.main.async {
            let currentDateTime = Date()

            // get the user's calendar
            let userCalendar = Calendar.current

            // choose which date and time components are needed
            let requestedComponents: Set<Calendar.Component> = [
                .hour,
                .minute,
                .second
            ]

            // get the components
            let time = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
            time.hour   // 22
            time.minute // 42
            time.second // 17

            self.textBox.text += " \(time.hour ?? 00):\(time.minute ?? 00):\(time.second ?? 00) \(type): \(string) \n"
        }
    }
//    func addBannerViewToView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        view.addConstraints(
//          [NSLayoutConstraint(item: bannerView,
//                              attribute: .bottom,
//                              relatedBy: .equal,
//                              toItem: bottomLayoutGuide,
//                              attribute: .top,
//                              multiplier: 1,
//                              constant: 0),
//           NSLayoutConstraint(item: bannerView,
//                              attribute: .centerX,
//                              relatedBy: .equal,
//                              toItem: view,
//                              attribute: .centerX,
//                              multiplier: 1,
//                              constant: 0)
//          ])
//       }
    func log(message: String) {
        print(message)
//            if self.textView != nil {
//                self.textView.text = self.textView.text + "\n" + message
//            } else {
//                self.logBeforeViewDidLoad = message
//            }
    }
    
    private func layoutBanner() {
        self.view.addSubview(banner)
        
        banner.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                banner.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                banner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func statusWithError(_ error: Any?) -> String {
        if let error = error {
            if("\(error)" == "CHBCacheErrorCodeNoAdFound"){
                
            
            if banner.superview == nil {
                        layoutBanner()
                    }
            banner.show(from: self)
        }
//                print(error)
            return "FAILED (\(error))"
        }
        return "SUCCESS"
    }
    
    // MARK: - Ad Delegate (Interstitial, Rewarded & Banner)
    
    func didCacheAd(_ event: CHBCacheEvent, error: CHBCacheError?) {
        log(message: "didCacheAd: \(type(of: event.ad)) \(statusWithError(error))")
    }
    
    func willShowAd(_ event: CHBShowEvent) {
        log(message: "willShowAd: \(type(of: event.ad))")
    }
    
    func didShowAd(_ event: CHBShowEvent, error: CHBShowError?) {
        log(message: "didShowAd: \(type(of: event.ad)) \(statusWithError(error))")
    }
    
    func shouldConfirmClick(_ event: CHBClickEvent, confirmationHandler: @escaping (Bool) -> Void) -> Bool {
        log(message: "shouldConfirmClick: \(type(of: event.ad))")
        return false
    }
    
    func didClickAd(_ event: CHBClickEvent, error: CHBClickError?) {
        log(message: "didClickAd: \(type(of: event.ad)) \(statusWithError(error))")
    }
    
    func didFinishHandlingClick(_ event: CHBClickEvent, error: CHBClickError?) {
        log(message: "didFinishHandlingClick: \(type(of: event.ad)) \(statusWithError(error))")
    }


    
}
extension Console: NFCNDEFReaderSessionDelegate {

// 1
func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
    print("Started scanning for tags")
}

// 2
func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    
    print("Detected tags with \(messages.count) messages")
    
    for messageIndex in 0 ..< messages.count {
        
        let message = messages[messageIndex]
        print("\tMessage \(messageIndex) with length \(message.length)")
        
        for recordIndex in 0 ..< message.records.count {
            
            let record = message.records[recordIndex]
            print("\t\tRecord \(recordIndex)")
//            textBox.text += "\(recordIndex)  \n"
//            textBox.text += "\t\t\tidentifier: \(String(data: record.identifier, encoding: .utf8)) \n"
//            textBox.text += "\t\t\ttype: \(String(data: record.type, encoding: .utf8)) \n"
            update(string: String(data: record.payload, encoding: .utf8) ?? "ERROR", type: "Read")
//            textBox.text += "Recieved: \(String(data: record.payload, encoding: .utf8) ?? "poop") \n"
            print("\t\t\tidentifier: \(String(data: record.identifier, encoding: .utf8))")
            print("\t\t\ttype: \(String(data: record.type, encoding: .utf8))")
            print("\t\t\tpayload: \(String(data: record.payload, encoding: .utf8))")
            
        }
    }
}

// 3
func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print("Session did invalidate with error: \(error)")
}
//write
}

