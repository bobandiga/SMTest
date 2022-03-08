//
//  Route.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 08.03.2022.
//

import Foundation

final class Route {

    // MARK: Private

    let delay: TimeInterval
    let data: Data
    let response: Response?


    // MARK: Public

    init(path: String,
         code: Int,
         delay: TimeInterval,
         httpVersion: HTTPVersion,
         mimeType: MimeType,
         data: Data) {

        self.delay = delay
        self.data = data

        self.response = Self.prepareResponse(path: path,
                                             data: data,
                                             code: code,
                                             httpVersion: httpVersion,
                                             mimeType: mimeType)
    }


    // MARK: Private

    private static func prepareResponse(path: String,
                                        data: Data,
                                        code: Int,
                                        httpVersion: HTTPVersion?,
                                        mimeType: MimeType?) -> Response? {

        guard let url = URL(string: path) else {
            return nil
        }

        let headers: [String: String] = [
            "Content-Type": mimeType?.rawValue,
            "Content-Length": String(data.count)
        ].compactMapValues { $0 }

        let response = Response(url: url,
                                statusCode: code,
                                headerFields: headers,
                                httpVersion: httpVersion?.rawValue)

        return response
    }
}


// MARK: Hashable

extension Route: Hashable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.response?.url == rhs.response?.url
    }


    func hash(into hasher: inout Hasher) {
        hasher.combine(response?.url)
    }
}
