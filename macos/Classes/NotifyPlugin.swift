import Cocoa
import FlutterMacOS
import CoreServices
import Foundation

var fakeBundleIdentifier: String? = nil

extension Bundle {
    @objc func __bundleIdentifier() -> String? {
        if self == Bundle.main {
            return fakeBundleIdentifier ?? "com.apple.Terminal"
        } else {
            return __bundleIdentifier()
        }
    }
}

func installNSBundleHook() -> Bool {
    let `class` = objc_getClass("NSBundle")
    if `class` != nil {
        if let identifier = class_getInstanceMethod((`class` as! AnyClass), #selector(getter: Bundle.bundleIdentifier)), let identifier1 = class_getInstanceMethod((`class` as! AnyClass), #selector(Bundle.__bundleIdentifier)) {
            method_exchangeImplementations(identifier, identifier1)
        }
        return true
    }
    return false
}

class NotificationCenterDelegate: NSObject, NSUserNotificationCenterDelegate {
    var keepRunning = false

    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        keepRunning = false
    }
}


func getBundleIdentifier(_ appName: String?) -> String? {
    let findString = "get id of application \"\(appName ?? "")\""
    let findScript = NSAppleScript(source: findString)
    let resultDescriptor = findScript?.executeAndReturnError(nil)
    return resultDescriptor?.stringValue
}


func setApplication(_ newbundleIdentifier: String?) -> Bool {
    if let identifier = newbundleIdentifier as CFString? {
        if LSCopyApplicationURLsForBundleIdentifier(identifier, nil) != nil {
            fakeBundleIdentifier = newbundleIdentifier
            return true
        }
    }
    return false
}

func scheduleNotification(_ title: String?, _ subtitle: String?, _ message: String?, _ sound: String?, _ deliveryDate: Double) -> Bool {
    autoreleasepool {
        if !installNSBundleHook() {
            return false
        }
        let scheduleTime = Date(timeIntervalSince1970: TimeInterval(deliveryDate))
        let nc = NSUserNotificationCenter.default
        let ncDelegate = NotificationCenterDelegate()
        ncDelegate.keepRunning = true
        nc.delegate = ncDelegate

        let note = NSUserNotification()
        note.title = title
        if !(subtitle == "") {
            note.subtitle = subtitle
        }
        note.informativeText = message
        note.deliveryDate = scheduleTime
        if !(sound == "_mute") {
            if !(sound == "_mute") {
                note.soundName = sound
            }
            nc.scheduleNotification(note)
            Thread.sleep(forTimeInterval: 0.1)
            return true
}
        return false
    }}

func sendNotification(_ title: String?, _ subtitle: String?, _ message: String?, _ sound: String?) -> Bool {
    autoreleasepool {
        if !installNSBundleHook() {
            return false
        }

        let nc = NSUserNotificationCenter.default
        let ncDelegate = NotificationCenterDelegate()
        ncDelegate.keepRunning = true
        nc.delegate = ncDelegate

        let note = NSUserNotification()
        note.title = title
        if !(subtitle == "") {
            note.subtitle = subtitle
        }
        note.informativeText = message
        if !(sound == "_mute") {
            note.soundName = sound
        }
        nc.deliver(note)

        Thread.sleep(forTimeInterval: 0.1)
        return true
    }
}

public class NotifyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "notify", binaryMessenger: registrar.messenger)
    let instance = NotifyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   
    switch call.method {
    case "getBundleIdentifier":
        let appName = (call.arguments as AnyObject)["appName"]! as? String
        result(String(getBundleIdentifier(appName) ?? ""))
    case "setApplication":
        let newbundleIdentifier = (call.arguments as AnyObject)["newbundleIdentifier"]! as? String
        setApplication(newbundleIdentifier)
        result("setApplication")
    case "sendNotification":
         let title = (call.arguments as AnyObject)["title"]! as? String
         let subtitle = (call.arguments as AnyObject)["subtitle"]! as? String
         let message = (call.arguments as AnyObject)["message"]! as? String
         let sound = (call.arguments as AnyObject)["sound"]! as? String
       
        sendNotification(title,
          subtitle,
          message,
        sound)
        result("sendNotification")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
