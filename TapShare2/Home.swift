//
//  Home.swift
//  TapShare2
//
//  Created by Ari Wasch on 10/14/20.
//

import Foundation
import UIKit
import GoogleMobileAds

let bannerID = "ca-app-pub-2716001497678491/2951612188"
//let bannerID = "ca-app-pub-3940256099942544/2934735716"

class Home: UIViewController, ChartboostDelegate, CHBBannerDelegate{

    private lazy var banner = CHBBanner(size: CHBBannerSizeStandard, location: CBLocationDefault, delegate: self)
    private var logBeforeViewDidLoad = String()

    var view1: ViewController = ViewController()
    let defaults = UserDefaults.standard
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        bannerView.adUnitID = bannerID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        addBannerViewToView(bannerView)


    }
    override func viewDidAppear(_ animated: Bool) {
        
        log(message: logBeforeViewDidLoad)
        if banner.superview == nil {
                    layoutBanner()
                }
        banner.show(from: self)

    }
    override func viewWillLayoutSubviews(){
        if(defaults.string(forKey: "start") != "finished"){
            performSegue(withIdentifier: "start", sender: nil)
        }

    }
    @IBAction func QR(_ sender: Any) {
        if(defaults.string(forKey: "link") == "" || defaults.string(forKey: "link") == nil){
            let alert = UIAlertController(title: "No link", message: "Please add a link to your social media, contact information, profile, or website in the Setup page.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Setup", style: UIAlertAction.Style.cancel, handler: {_ in
                self.performSegue(withIdentifier: "setup", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }else{
        let image = generateQRCode(from: defaults.string(forKey: "link") ?? "https://google.com")
            let showAlert = UIAlertController(title: "QR Code", message: nil, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 250))
        imageView.image = image // Your image here...
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            // your actions here...
        }))
        self.present(showAlert, animated: true, completion: nil)
        }
    }
    @IBAction func share(_ sender: Any) {
        if(defaults.string(forKey: "link") == "" || defaults.string(forKey: "link") == nil){
            let alert = UIAlertController(title: "No link", message: "Please add a link to your social media, contact information, profile, or website in the Setup page.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Setup", style: UIAlertAction.Style.cancel, handler: {_ in
                self.performSegue(withIdentifier: "setup", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }else{
        print(defaults.string(forKey: "link"))
        let fileUrl = URL(string: defaults.string(forKey: "link")!)
//        let dataToShare: NSData = NSData(contentsOf: fileUrl!)
        guard let imageURL = fileUrl else { return  }

            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let imageData: Data = try Data(contentsOf: imageURL)

                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                    }
                }catch{
                        print("Unable to load data: \(error)")
                }
            }

        let controller = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
//        controller.excludedActivityTypes = [UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypeMail, UIActivityTypeAddToReadingList, UIActivityTypeOpenInIBooks, UIActivityTypeMessage]

        self.present(controller, animated: true, completion: nil)

        }
    }
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
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
    
        
        //MARK: - Other
            
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

