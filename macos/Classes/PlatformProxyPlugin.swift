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
                            
                            let systemProxy = CFNetworkCopySystemProxySettings()?.takeRetainedValue()
                            let passQuery: [String: Any] = [
                                kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: "127.0.0.1",
                                kSecAttrProtocolHTTPS as String: true,
                                kSecAttrPort as String: "8080",
                                kSecAttrAccount as String: "user",
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true
                            ]
                            let autoProxyItem: CFTypeRef?
                            let mySelf = self
                            var clientContext = CFStreamClientContext()
                            clientContext.retain = &mySelf
                            let autoProxy = CFNetworkExecuteProxyAutoConfigurationScript("http://localhost:8081?host=127.0.0.1&port=8080" as CFString, url, {(a,b,c) in print(b)}, UnsafeMutablePointer(&clientContext))
                            var passItem: CFTypeRef?
                            let status = SecItemCopyMatching(passQuery as CFDictionary, &passItem)
                            //                            guard status != errSecItemNotFound else { throw KeychainError.noPassword }
                            //                            guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
                            result("Arguments: \(args) Proxies: \(proxies) Item: \(item) SystemProxy: \(systemProxy), Pass Item: \(passItem)")
                            //                            if let itemDict = item as? NSDictionary {
                            //                                result(itemDict["kCFProxyTypeKey"] as? String ?? "No")
                            //                            }
                            //                            else {result("Arguments: \(args) Proxies: \(proxies) Item: \(item)")}
                        }
                    }}
                else {
                    result("")
                }}
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func autoProxyExecuteResultCallback(_ client: UnsafeMutableRawPointer, _ proxies: CFArray, _ error: CFError?) {
        print(proxies)
    }
}
