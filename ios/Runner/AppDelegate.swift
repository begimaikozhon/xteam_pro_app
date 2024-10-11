import Flutter
import UIKit
import GoogleMaps // Импортируем Google Maps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Устанавливаем API ключ для Google Maps
    GMSServices.provideAPIKey("AIzaSyAdvFE9rktIMVBOAA766GhtCuQ7bW1S3ec")
    
    // Регистрируем плагины
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
