//
//  ViewController.swift
//  NFC Digital Keypad
//
//  Created by Ari Wasch on 12/24/19.
//  Copyright © 2019 Ari Wasch. All rights reserved.
//

import UIKit
import CoreNFC
class ViewController: UIViewController {
    var result: String = ""
    var done: Bool = false
    var write: Bool = false
    public var recordText: String = ""
    public var recordText2: String = ""
    var otherTrue: Bool = false
    let defaults = UserDefaults.standard
    @IBOutlet weak var sendText: UITextField!
    var mess: String = "hello world"
    
    var message = NFCNDEFMessage.init(
        records: [
            NFCNDEFPayload.wellKnownTypeURIPayload(
                string: "hello world")!
        ]
    )
    var session: NFCNDEFReaderSession?
    
    func ViewController(){
        
    }
//    func returnWords() -> String{
//        print(ViewController.recordText)
//        return ViewController.recordText
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        sendText.text = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set("", forKey: "record")
        recordText = ""

    }
    @IBAction func backSpace(_ sender: Any) {
        var temp: String = ""
        if(sendText.text != ""){
            temp = sendText.text ?? "error"
            temp = String(temp.dropLast())
            sendText.text = temp
        }
    }
    @IBAction func one(_ sender: Any) {
        sendText.text! += "1"
    }
    @IBAction func two(_ sender: Any) {
        sendText.text! += "2"
    }
    @IBAction func three(_ sender: Any) {
        sendText.text! += "3"
    }
    @IBAction func four(_ sender: Any) {
        sendText.text! += "4"
    }
    @IBAction func five(_ sender: Any) {
        sendText.text! += "5"
    }
    @IBAction func six(_ sender: Any) {
        sendText.text! += "6"
    }
    @IBAction func seven(_ sender: Any) {
        sendText.text! += "7"
    }
    @IBAction func eight(_ sender: Any) {
        sendText.text! += "8"
    }
    @IBAction func nine(_ sender: Any) {
        sendText.text! += "9"
    }
    @IBAction func zero(_ sender: Any) {
        sendText.text! += "0"
    }
    @IBAction func A(_ sender: Any) {
        sendText.text! += "A"
    }
    @IBAction func B(_ sender: Any) {
        sendText.text! += "B"
    }
    @IBAction func C(_ sender: Any) {
        sendText.text! += "C"
    }
    @IBAction func D(_ sender: Any) {
        sendText.text! += "D"
    }
    @IBAction func asterick(_ sender: Any) {
        sendText.text! += "*"
    }
    @IBAction func hashtag(_ sender: Any) {
        sendText.text! += "#"
    }
    func startWrite(m: String){
        guard NFCReaderSession.readingAvailable else {
            return
        }
        write = true
        mess = m
        message = NFCNDEFMessage.init(
            records: [
                NFCNDEFPayload.wellKnownTypeURIPayload(
                    string: m)!
            ]
        )
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near an NDEF tag to write the message."
        session?.begin()
    }
    
    
    @IBAction func send(_ sender: Any) {
        if(sendText.text != ""){
            startWrite(m: sendText.text ?? "defualt")
            sendText.text = ""
        }
    }
    
    
}
extension ViewController: NFCNDEFReaderSessionDelegate {

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
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if(write){
        if tags.count > 1 {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        // Connect to the found tag and write an NDEF message to it.
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
                session.alertMessage = "Unable to connect to tag."
                self.done = true
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    self.result = "Unable to query the NDEF status of tag."
                    self.done = true
                    session.invalidate()
                    return
                }

                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    self.result = "Tag is not NDEF compliant."
                    var recordText = "Tag is not NDEF compliant."
                    self.done = true
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    self.result = "Tag is read only."
                    self.recordText = "Tag is read only."
                    self.done = true
                    session.invalidate()
                case .readWrite:
                    
                    tag.writeNDEF(self.message, completionHandler: { (error: Error?) in
                        if nil != error {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                            self.recordText = "Write NDEF message fail"
                        } else {

                            session.alertMessage = "Write NDEF message successful."
                        DispatchQueue.main.async {
                            let currentDateTime = Date()
                            let userCalendar = Calendar.current
                            let requestedComponents: Set<Calendar.Component> = [
                                .hour,
                                .minute,
                                .second
                            ]
                            let time = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
                            time.hour   // 22
                            time.minute // 42
                            time.second // 17
                            self.recordText += " \(time.hour ?? 00):\(time.minute ?? 00):\(time.second ?? 00) Write: \(self.mess) \n"
                            UserDefaults.standard.set(self.recordText, forKey: "record")

                            }
//                            console1.update(string: message, type: <#T##String#>) = "success"
                        }
                        print(self.recordText)

                        self.done = true
                        UserDefaults.standard.set("true", forKey: "key")
                        session.invalidate()
                    })
                    
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    self.result = "Unknown NDEF tag status."
                    self.recordText = "Unknown NDEF tag status."
                    self.done = true
                    session.invalidate()
                }
            })
        })
        }
        }
    }


