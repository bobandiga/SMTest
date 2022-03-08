//
//  XCTest+Runloop.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import XCTest

public extension XCTest {
    
    func maintainRunloop(count: Int = 1) {
        guard Thread.isMainThread else {
            XCTFail("Thread must be main")
            return
        }

        for _ in 0..<count {
            RunLoop.current.run(until: Date())
        }
    }

    func wait(_ delay: TimeInterval) {
        let delayExpectation = XCTestExpectation(description: "delay")
        let timer = Timer(timeInterval: delay, repeats: true) { timer in
            timer.invalidate()
            delayExpectation.fulfill()
        }

        RunLoop.current.add(timer, forMode: .common)
        XCTWaiter().wait(for: [delayExpectation], timeout: delay)
    }

    func wait(_ delay: TimeInterval, condition: @autoclosure () -> Bool) {
        let startDate = Date()

        while !condition() {
            guard Date().timeIntervalSince(startDate) < delay else {
                return
            }

            RunLoop.current.run(until: Date())
        }
    }
}
