//
//  AppDelegate.swift
//  Flickr Finder
//
//  Created by Antonio Allen on 4/6/19.
//  Copyright © 2019 Antonio Allen. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var networkService: NetworkService = {
        let networkService = NetworkService(network: NetworkSupportNative())
        return networkService
    }()
    
    // Cordinator
    private lazy var appCoordinator: AppCoordinator = {
        return AppCoordinator(in: window!, networkService: networkService)
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Create main window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Start coordinator
        appCoordinator.start()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
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
        let container = NSPersistentContainer(name: "Flickr_Finder")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension UIApplication {
    
    var appDelegate: AppDelegate? {
        return delegate as? AppDelegate
    }
}
