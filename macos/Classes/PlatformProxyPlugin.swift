import Cocoa
import Foundation
import FlutterMacOS

public class PlatformProxyPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "platform_proxy", binaryMessenger: registrar.messenger)
        let instance = PlatformProxyPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "getPlatformProxy":
            if let args = call.arguments as? [String:String] {
                if let urlArg = args["url"] {
                    if let url = URL(string: urlArg) as CFURL? {
                        if let proxySettingsUnmanaged = CFNetworkCopySystemProxySettings() {
                            let proxySettings = proxySettingsUnmanaged.takeRetainedValue()
                            let proxiesUnmanaged = CFNetworkCopyProxiesForURL(url, proxySettings)
                            let proxies = proxiesUnmanaged.takeRetainedValue() as NSArray;
                            // https://developer.apple.com/documentation/cfnetwork/property_keys
                            // [1]    (null)    "kCFProxyTypeKey" : "kCFProxyTypeAutoConfigurationURL"
                            //kCFProxyAutoConfigurationURLKey
                            // [0]    (null)    "kCFProxyTypeKey" : "kCFProxyTypeNone"
                            let item = proxies[0];
                            if let itemDict = item as? NSDictionary {
                                result(itemDict["kCFProxyTypeKey"] as? String ?? "No")
                            }
                            else {result("Arguments: \(args) Proxies: \(proxies) Item: \(item)")}
                        }
                    }}
                else {
                    result("")
                }}
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
