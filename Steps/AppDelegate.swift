//
//  AppDelegate.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import CoreData
import Font_Awesome_Swift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func makeTitle(titleText:String) -> UIButton {
        let navTitle = UIButton(type: .custom)
        navTitle.setTitle(titleText, for: .normal)
        navTitle.titleLabel?.font = UIFont.init(customFont: .ProximaNovaLight, withSize: 20)
        navTitle.setTitleColor(UIColor.MNTextGray, for: .normal)
        return navTitle
    }
    func makeNavTextButton(text:String) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 38, height: 34)
        button.setTitle(text, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.init(customFont: .ProximaNovaLight, withSize: 20)
        button.setTitleColor(UIColor.MNTextGray, for: .normal)
        return UIBarButtonItem(customView: button)
    }
    
    
    func barButton(icon:FAType, selector:Selector) -> UIBarButtonItem {
        let b = UIButton(type: .custom)
        b.setFAIcon(icon: icon, iconSize: 30, forState: UIControlState.normal)
//        b.setImage(image, for: .normal)
        b.contentHorizontalAlignment = .right
        b.frame = CGRect(x: 0, y: 0, width: 30, height: 0)
        b.backgroundColor = .yellow
        b.addTarget(self, action: selector, for: .touchUpInside)
        let button = UIBarButtonItem(customView: b)
        return button
    }

    var currentController:TaskStepsController!
    
    func NavigateToTaskSteps(taskIndex:Int) {
        let controller = TaskStepsController()
        controller.taskIndex = taskIndex
        controller.navigationItem.titleView = makeTitle(titleText: "Steps")
        controller.navigationItem.leftBarButtonItem = barButton(icon:.FAArrowLeft, selector: #selector(self.insertStep))
        controller.navigationItem.rightBarButtonItem = barButton(icon: .FAPlus, selector: #selector(self.removeStep))
        navigationController.pushViewController(controller, animated: true)
        currentController = controller
    }
    
    func insertStep() {
        currentController.InsertStep()
    }
    
    func removeStep() {
        currentController.deleteStep(at: currentController.taskIndex)
    }
    
    func backToTasks() {
        navigationController.popViewController(animated: true)
    }
    
    var window: UIWindow?
    var navigationController:UINavigationController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().barTintColor = UIColor.MNGray
        
        let taskController = TaskController()
        taskController.navigationItem.titleView = makeTitle(titleText: "Tasks")
        taskController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "recycling-bin"), rect: CGRect(x: 0, y: 0, width: 26, height: 26)))//makeNavTextButton(text: "Edit")
        taskController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "cogwheel-outline"), rect: CGRect(x: 0, y: 0, width: 26, height: 26)))
        
        let taskNavItem = UINavigationController(rootViewController: taskController)
        taskNavItem.tabBarItem.setFAIcon(icon: .FACircleO, size: nil, orientation: .up, textColor: UIColor.white, backgroundColor: UIColor.clear, selectedTextColor: UIColor.MNGreen.withAlphaComponent(1), selectedBackgroundColor: .clear)
        taskNavItem.tabBarItem.title = "Tasks"
        taskNavItem.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.init(customFont: .ProximaNovaLight, withSize: 16)!, NSForegroundColorAttributeName:UIColor.white], for: .normal)

        
        let todayController = TaskController()
        todayController.navigationItem.titleView = makeTitle(titleText: "Finish Today")
        
        let todayNavItem = UINavigationController(rootViewController: todayController)
        todayNavItem.tabBarItem.setFAIcon(icon: .FACalendarO, size: nil, orientation: .up, textColor: UIColor.white, backgroundColor: UIColor.clear, selectedTextColor: UIColor.MNGreen.withAlphaComponent(1), selectedBackgroundColor: .clear)
        todayNavItem.tabBarItem.title = "Today"
        todayNavItem.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.init(customFont: .ProximaNovaLight, withSize: 16)!, NSForegroundColorAttributeName:UIColor.white], for: .normal)


        
        
        let tabController = UITabBarController()
        tabController.tabBar.barTintColor = UIColor.MNGray
        
        tabController.viewControllers = [taskNavItem, todayNavItem]
        
        navigationController = UINavigationController()
        navigationController.viewControllers.append(tabController)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.MNGray
       
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Steps")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

