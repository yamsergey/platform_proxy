import Foundation
import JavaScriptCore

public class PlatformProxyConfig: NSObject {
    
    var dictionary: NSDictionary
    
    public init(_ dictionary: NSDictionary) {
        self.dictionary = dictionary
    }    
    
    public func toJson() -> String {
        return "";
    }
}
