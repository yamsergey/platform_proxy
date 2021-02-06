//
//  platform_proxy_exampleTests.swift
//  platform_proxy_exampleTests
//
//  Created by Sergey Yamshchikov on 05.02.21.
//

import XCTest
import platform_proxy

class platform_proxy_exampleTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNoneProxyConfigSerialisasition() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyTypeKey" : "kCFProxyTypeNone"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
    
    func testAutoProxyConfigSerialisasition() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyAutoConfigurationURLKey": "http://autoproxy.com",
            "kCFProxyTypeKey" : "kCFProxyTypeAutoConfigurationURL"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
    
    func testAutoProxyJavascriptConfigSerialisation() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyAutoConfigurationURLKey": "http://autoproxy.com",
            "kCFProxyTypeKey" : "kCFProxyTypeAutoConfigurationJavaScript"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
    
    func testManualHttpProxyConfigSerialisation() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyHostNameKey": "localhost",
            "kCFProxyPortNumberKey": "8888",
            "kCFProxyTypeKey" : "kCFProxyTypeHTTP"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
    
    func testManualHttpsProxyConfigSerialisation() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyHostNameKey": "localhost",
            "kCFProxyPortNumberKey": "8888",
            "kCFProxyTypeKey" : "kCFProxyTypeHTTPS"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
    
    func testManualSocksProxyConfigSerialisation() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyHostNameKey": "localhost",
            "kCFProxyPortNumberKey": "8888",
            "kCFProxyTypeKey" : "kCFProxyTypeSOCKS"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
    
    func testManualFtpProxyConfigSerialisation() throws {
        let proxyConfig = PlatformProxyConfig([
            "kCFProxyHostNameKey": "localhost",
            "kCFProxyPortNumberKey": "8888",
            "kCFProxyTypeKey" : "kCFProxyTypeFTP"
            ]
        )
        XCTAssert("hello" == proxyConfig.toJson())
    }
}
