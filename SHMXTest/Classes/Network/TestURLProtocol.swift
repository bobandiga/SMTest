//
//  StubURLProtocol.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 07.03.2022.
//

import Foundation
import XCTest

final class TestURLProtocol: URLProtocol {

    // MARK: Private properties
    
    private static var routes: Set<Route> = []

    private static let workingQueue = DispatchQueue(label: "TestURLProtocolQueue")
    private static var executedItem: DispatchWorkItem?


    // MARK: Public

    static func addRoute(route: Route) {
        workingQueue.sync {
            routes.insert(route)
        }
    }
}

// MARK: - URLProtocol

extension TestURLProtocol {

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return workingQueue.sync {
            return executedItem == nil
        }
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        return workingQueue.sync {
            return executedItem == nil
        }
    }

    override func startLoading() {
        do {
            let url = try XCTUnwrap(self.request.url)
            let route = try XCTUnwrap(Self.routes.filter({ $0.response != nil }).first(where: { $0.response?.url == url }))
            let routeResponse = try XCTUnwrap(route.response)
            guard routeResponse.statusCode == 200 else {
                throw NSError.init(domain: NSURLErrorDomain,
                                   code: routeResponse.statusCode,
                                   userInfo: [
                    NSURLErrorFailingURLStringErrorKey: routeResponse.url.absoluteString
                ])
            }

            let response = try XCTUnwrap(HTTPURLResponse(response: routeResponse))

            let item = DispatchWorkItem { [weak self] in
                guard let self = self else { return }

                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: route.data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
            item.notify(queue: Self.workingQueue) {
                /// Remove stub
                Self.routes.remove(route)
            }

            Self.executedItem = item
            Self.workingQueue.asyncAfter(deadline: .now() + route.delay, execute: item)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        Self.executedItem?.cancel()
        Self.executedItem = nil
    }
}
