//
//  FirstTest.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 28.01.2022.
//

import XCTest
import SHMXTest

final class FirstTestwwww: BaseSnapshotUnitTestCase {

    func testExample132() throws {

        let vc1 = UIViewController()
        vc1.view.backgroundColor = .blue

        let window = prepareWindow(vc1).window

        let vc2 = UIViewController()
        vc2.view.backgroundColor = .gray


        network.errorRoute(url: "https://jsonplaceholder.typicode.com/todos") {
            return "asdasd".data(using: .utf8)!
        }

        let task = URLSession(configuration: .default).dataTask(with: URL(string: "https://jsonplaceholder.typicode.com/todos")!) { data, response, error in
            print(response)
            print(error)
            print(data)
        }
        task.resume()

        present(from: vc1, to: vc2)

        assertSnapshot(view: window, identifier: "000", isRecording: true, delay: 10)
    }
}
