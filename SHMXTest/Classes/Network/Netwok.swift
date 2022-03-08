//
//  Netwok.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 08.03.2022.
//

import Foundation

public struct Netwok {

    // MARK: Lifecycle

    public init() {
        swizzleURLSession()
    }


    // MARK: Public

    public func addRoute(url: String,
                        code: Int,
                        delay: TimeInterval,
                        httpVersion: String?,
                        mimeType: MimeType?,
                        _ data: @escaping () -> Data) {

        let httpVersion = HTTPVersion(rawValue: httpVersion ?? "HTTP/1.1") ?? .http1
        let mimeType = mimeType ?? .json
        let data = data()

        let route = Route(path: url,
                          code: code,
                          delay: delay,
                          httpVersion: httpVersion,
                          mimeType: mimeType,
                          data: data)

        TestURLProtocol.addRoute(route: route)
    }


    // MARK: Private

    private func swizzleURLSession() {
        let shortInit1 = class_getClassMethod(URLSession.self, #selector(URLSession.init(configuration:)))
        let shortInit2 = class_getClassMethod(URLSession.self, #selector(URLSession.swizzled_init(configuration:)))
        if let shortInit1 = shortInit1, let shortInit2 = shortInit2 {
            method_exchangeImplementations(shortInit1, shortInit2)
        }

        let fullInit1 = class_getClassMethod(URLSession.self, #selector(URLSession.init(configuration:delegate:delegateQueue:)))
        let fullInit2 = class_getClassMethod(URLSession.self, #selector(URLSession.swizzled_init(configuration:delegate:delegateQueue:)))
        if let fullInit1 = fullInit1, let fullInit2 = fullInit2 {
            method_exchangeImplementations(fullInit1, fullInit2)
        }
    }
}

// MARK: Swizzling

private extension URLSession {
    @objc dynamic class func swizzled_init(configuration: URLSessionConfiguration) -> URLSession {
        configuration.protocolClasses = [TestURLProtocol.self] + configuration.protocolClasses!
        return swizzled_init(configuration: configuration)
    }

    @objc dynamic class func swizzled_init(configuration: URLSessionConfiguration,
                                           delegate: URLSessionDelegate?,
                                           delegateQueue: OperationQueue?) -> URLSession {
        configuration.protocolClasses = [TestURLProtocol.self] + configuration.protocolClasses!
        return swizzled_init(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }
}
