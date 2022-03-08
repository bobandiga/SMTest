//
//  Netwok+Routes.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 08.03.2022.
//

import Foundation

public extension Netwok {

    func successRoute(url: String, data: @escaping () -> Data) {
        addRoute(url: url, code: 200, delay: 0, httpVersion: nil, mimeType: nil, data)
    }

    func successRoute(url: String, mimeType: MimeType, data: @escaping () -> Data) {
        addRoute(url: url, code: 200, delay: 0, httpVersion: nil, mimeType: mimeType, data)
    }

    func successRoute(url: String, delay: TimeInterval, data: @escaping () -> Data) {
        addRoute(url: url, code: 200, delay: delay, httpVersion: nil, mimeType: nil, data)
    }

    func successRoute(url: String, delay: TimeInterval, mimeType: MimeType, data: @escaping () -> Data) {
        addRoute(url: url, code: 200, delay: delay, httpVersion: nil, mimeType: nil, data)
    }

    func errorRoute(url: String, data: @escaping () -> Data) {
        addRoute(url: url, code: 400, delay: 0, httpVersion: nil, mimeType: nil, data)
    }
}
