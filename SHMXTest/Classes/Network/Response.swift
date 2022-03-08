//
//  StubResponse.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 08.03.2022.
//

import Foundation

struct Response: Hashable {
    let url: URL
    let statusCode: Int
    let headerFields: [String : String]?
    let httpVersion: String?
}

extension HTTPURLResponse {
    convenience init?(response: Response) {
        self.init(url: response.url,
                  statusCode: response.statusCode,
                  httpVersion: response.httpVersion,
                  headerFields: response.headerFields)
    }
}
