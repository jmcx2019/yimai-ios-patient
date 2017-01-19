//
//  AppDelegate.swift
//  YiMaiPatient
//
//  Created by ios-dev on 16/8/13.
//  Copyright © 2016年 yimai. All rights reserved.
//

import UIKit
import CoreData
import UMSocialCore
import UMSocialNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    var NotifyCationProcession = false

    func RegisterNotification(app: UIApplication) {
        let types = UIUserNotificationType(rawValue: UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Alert.rawValue)
        let notificationSetting = UIUserNotificationSettings(forTypes: types, categories: nil)
        
        app.registerUserNotificationSettings(notificationSetting)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        YMVar.DeviceToken = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        YMVar.DeviceToken = YMVar.DeviceToken.stringByReplacingOccurrencesOfString(" ", withString: "")
        UMessage.registerDeviceToken(deviceToken)
        print("remote push register success \(YMVar.DeviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("remote push register failed")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.NewData)
        
        UMessage.setAutoAlert(false)
        
        if(0 == YMVar.MyInfo.count) {
            application.applicationIconBadgeNumber = 0
            return
        }
        
        let action = userInfo["action"] as? String
        
        if(nil == action) {
            application.applicationIconBadgeNumber = 0
            return
        }
        
        let ctrl = window?.rootViewController as? UINavigationController
        
        if(nil == ctrl) {
            application.applicationIconBadgeNumber = 0
            return
        }
        
        if(application.applicationState != UIApplicationState.Active) {
            YMNotificationHandler.HandlerMap[action!]?(ctrl!, userInfo)
            completionHandler(UIBackgroundFetchResult.NewData)
        } else {
            completionHandler(UIBackgroundFetchResult.NoData)
        }
        
        application.applicationIconBadgeNumber = 0
    }
    
    func GoToBroadCast() {
//        if(NotifyCationProcession) {
//            return
//        }
        
        if(0 == YMVar.MyInfo.count) {
            return
        }
//
//        NotifyCationProcession = true
//        if(YMCommonStrings.CS_PAGE_INDEX_NAME != YMCurrentPage.CurrentPage) {
//            YMDelay(0.5, closure: {
//                self.GoToBroadCast()
//            })
//        }
//        NotifyCationProcession = false
        let ctrl = window?.rootViewController as? UINavigationController
        PageJumpActions(navController: ctrl).DoJump(YMCommonStrings.CS_PAGE_SYS_BROADCAST)
        
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        YMCoreDataEngine.EngineInitialize()
        WXApi.registerApp("wx2097e8b109f9dc35", withDescription: "YiMaiPatient-1.0")
        
        UMessage.startWithAppkey("58770533c62dca6297001b7b", launchOptions: launchOptions)
        UMessage.registerForRemoteNotifications()
        UMessage.setLogEnabled(true)
        
//        RegisterNotification(application)
        application.applicationIconBadgeNumber = 0

        UMSocialManager.defaultManager().openLog(true)
        UMSocialManager.defaultManager().umSocialAppkey = "58073c2ae0f55a4ac00023e4"
        
        UMSocialManager.defaultManager().setPlaform(UMSocialPlatformType.WechatSession,
                                                    appKey: "wx2097e8b109f9dc35", appSecret: "555d4062c619451b884267c46ab85ca3",
                                                    redirectURL: "https://www.medi-link.cn")

        UMSocialManager.defaultManager().setPlaform(UMSocialPlatformType.Sina,
                                                    appKey: "1075290971", appSecret: "ebd03c962864546d7b5e854f2b4a8dc1",
                                                    redirectURL: "https://www.medi-link.cn")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.yimai.patient.YiMaiPatient" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("YiMaiPatient", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        print("openURL:\(url.absoluteString)")

        if (url.scheme == "wx2097e8b109f9dc35") {
            return WXApi.handleOpenURL(url, delegate: self)
        }
        
        return false
    }
    
    //wx pay callback
    func onResp(resp: BaseResp!) {
        let ctrl = window?.rootViewController as? UINavigationController
        let targetCtrl = ctrl?.viewControllers.last

        if resp.isKindOfClass(PayResp) {
            switch resp.errCode {
            case 0 :
                targetCtrl?.YMUpdateStateFromWXPay()
            default:
                targetCtrl?.YMShowErrorFromWXPay()
            }
        }
    }
}

func YMDelay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

