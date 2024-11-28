import Flutter
import UIKit
import GoogleMaps
import flutter_background_service_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   SwiftFlutterBackgroundServicePlugin.taskIdentifier = "dev.flutter.background.refresh"
   BGTaskScheduler.shared.register(forTaskWithIdentifier: "dev.flutter.background.refresh", using: nil) { task in
        self.handleAppRefresh(task: task as! BGAppRefreshTask)
   }
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyCrMgdpxLN0lxbicIc9kBYSJsWo9pXk8gY")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func scheduleAppRefresh() {
     let request = BGAppRefreshTaskRequest(identifier: "dev.flutter.background.refresh")
     // Fetch no earlier than 15 minutes from now.
     request.earliestBeginDate = Date(timeIntervalSinceNow: 5)

     do {
        try BGTaskScheduler.shared.submit(request)
     } catch {
        print("Could not schedule app refresh: \(error)")
     }
     func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new refresh task.
        scheduleAppRefresh()


        // Create an operation that performs the main part of the background task.
        let operation = RefreshAppContentsOperation()

        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
           operation.cancel()
        }


        // Inform the system that the background task is complete
        // when the operation completes.
        operation.completionBlock = {
           task.setTaskCompleted(success: !operation.isCancelled)
        }


        // Start the operation.
        operationQueue.addOperation(operation)
      }
  }

}
