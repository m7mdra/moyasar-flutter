import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Add this line before GeneratedPluginRegistrant
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // This line is added by the Flutter App Generator
        GeneratedPluginRegistrant.register(with: self)
        
        // Add these lines after GeneratedPluginRegistrant
        let navigationController = UINavigationController(rootViewController: flutterViewController);
        navigationController.setNavigationBarHidden(true, animated: false);
        
        self.window = UIWindow(frame: UIScreen.main.bounds);
        self.window.rootViewController = navigationController;
        self.window.makeKeyAndVisible();
        // End of edit
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
