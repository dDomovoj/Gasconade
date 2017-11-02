//
//  AppDelegate.swift
//
//  Created by Dmitry Duleba on 11/2/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit
import GameConnect

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  lazy var containerController = GCContainerViewController()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupGC()
    return true
  }
}

private extension AppDelegate {

  func setupGC() {
    //    @property (nonatomic, copy) NSString *pmuLogo;
    //    @property (nonatomic, copy) NSString *awardsEnURLString;
    //    @property (nonatomic, copy) NSString *awardsFrURLString;
    //    @property (nonatomic, copy) NSString *regulationsURLString;
    //    @property (nonatomic, copy) NSString *pmuWebsiteURLString;
    //    @property (nonatomic, copy) NSString *pmuPSGWiFiWebsiteURLString;
    //    @property (nonatomic, copy) NSString *pixelURLString;
    //    @property (nonatomic, copy) NSString *pmuPartnershipURLString;

    //    currentGCContainer = GCContainerViewController()
    //    currentGCContainer?.view.layoutIfNeeded()
    //    GCAPPNavigationManageriPhone.getInstance().isWatchingGameConnect = {
    //      guard let controllerForPresenting = self.window?.rootViewController else {
    //        return false
    //      }
    //      var currentController: UIViewController? = controllerForPresenting
    //      while currentController != nil {
    //        if currentController is GCContainerViewController {
    //          return true
    //        }
    //        if let controller = currentController {
    //          let proposedController = self.controllerForPresenting(from: controller)
    //          if proposedController != controller {
    //            currentController = proposedController
    //          } else {
    //            return false
    //          }
    //        }
    //      }
    //      return false
    //    }
  }

  func openGC() {
    //    controllerForPresenting?.present(gcContainerViewController, animated: true)
  }

  func closeGC() {
    //    currentGCContainer?.dismiss(animated: true, completion: nil)
  }
}

