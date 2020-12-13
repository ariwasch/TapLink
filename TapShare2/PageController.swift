//
//  PageViewController.swift
//  NFC Digital Keypad
//
//  Created by Ari Wasch on 12/24/19.
//  Copyright © 2019 Ari Wasch. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, ChartboostDelegate, CHBBannerDelegate {

    private lazy var banner = CHBBanner(size: CHBBannerSizeStandard, location: CBLocationDefault, delegate: self)
    private var logBeforeViewDidLoad = String()

var pageControl = UIPageControl()
var bannerView: GADBannerView!

// MARK: UIPageViewControllerDataSource

lazy var orderedViewControllers: [UIViewController] = {
    return [self.newVc(viewController: "one"),
            self.newVc(viewController: "two"),
            self.newVc(viewController: "three"),
            self.newVc(viewController: "four")]}()

override func viewDidLoad() {
    var pageControl = UIPageControl()
    super.viewDidLoad()
    self.delegate = self
//    configurePageControl()
    self.dataSource = self
//    log(message: logBeforeViewDidLoad)
//    if banner.superview == nil {
//                layoutBanner()
//            }
//    banner.show(from: self)

//    bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//    bannerView.adUnitID = bannerID
//    bannerView.rootViewController = self
//    bannerView.load(GADRequest())
//    addBannerViewToView(bannerView)
//
//
//    // This sets up the first view that will show up on our page control
    if let firstViewController = orderedViewControllers.first {
        setViewControllers([firstViewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
//    configurePageControl()
    
    // Do any additional setup after loading the view.
}
    override func viewDidAppear(_ animated: Bool) {
        
        log(message: logBeforeViewDidLoad)
        if banner.superview == nil {
                    layoutBanner()
                }
        banner.show(from: self)

    }


func configurePageControl() {
    // The total number of pages that are available is based on how many available colors we have.
    pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
    self.pageControl.numberOfPages = orderedViewControllers.count
    self.pageControl.currentPage = 0
    self.pageControl.tintColor = UIColor.black
    self.pageControl.pageIndicatorTintColor = UIColor.white
    self.pageControl.currentPageIndicatorTintColor = UIColor.black
    self.view.addSubview(pageControl)
}

func newVc(viewController: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
}


// MARK: Delegate methords
func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    let pageContentViewController = pageViewController.viewControllers![0]
    self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
}

// MARK: Data source functions.
func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
        return nil
    }
    
    let previousIndex = viewControllerIndex - 1
    
    // User is on the first view controller and swiped left to loop to
    // the last view controller.
    guard previousIndex >= 0 else {
        return orderedViewControllers.last
        // Uncommment the line below, remove the line above if you don't want the page control to loop.
        // return nil
    }
    
    guard orderedViewControllers.count > previousIndex else {
        return nil
    }
    
    return orderedViewControllers[previousIndex]
}

func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
        return nil
    }
    
    let nextIndex = viewControllerIndex + 1
    let orderedViewControllersCount = orderedViewControllers.count
    
    // User is on the last view controller and swiped right to loop to
    // the first view controller.
    guard orderedViewControllersCount != nextIndex else {
        return orderedViewControllers.first
        // Uncommment the line below, remove the line above if you don't want the page control to loop.
        // return nil
    }
    
    guard orderedViewControllersCount > nextIndex else {
        return nil
    }
    
    return orderedViewControllers[nextIndex]
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
