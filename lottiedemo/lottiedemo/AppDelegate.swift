

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var initViewController: PlayViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //初回起動判定
        if UserDefaults.standard.object(forKey: "firstLaunch") == nil {
            firstLaunch()
        }
        initViewController = PlayViewController()
        let nav: UINavigationController = UINavigationController(rootViewController: initViewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)

        let toDir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first
        do {
            try? FileManager.default.removeItem(at: toDir!.appendingPathComponent( url.lastPathComponent))
            try FileManager.default.moveItem(at: url, to: toDir!.appendingPathComponent( url.lastPathComponent))
            UserDefaults.standard.set(url.lastPathComponent, forKey: "filename")
            if initViewController.animationView != nil {
                initViewController.viewWillAppear(true)
            }
        } catch {
            print("copy error")
            return false
        }
        return true
    }
    
    //初回起動処理
    func firstLaunch(){
        
        let demos = ["demo1","demo2","demo3"]
        for demo in demos{
            let url = URL(fileURLWithPath: Bundle.main.path( forResource: demo, ofType: "json" )! )
            let toDir = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask ).first
            do {
                try FileManager.default.copyItem(at: url, to: toDir!.appendingPathComponent( url.lastPathComponent))
            } catch {
                print("copy error")
            }
        }
        
        UserDefaults.standard.set("demo1.json", forKey: "filename")
        UserDefaults.standard.set(1, forKey: "firstLaunch")
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
    }


}

