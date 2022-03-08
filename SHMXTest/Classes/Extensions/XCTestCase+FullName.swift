//
//  XCTestCase+FullName.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 06.03.2022.
//

import Foundation
import XCTest

extension XCTestCase {

    var testClassName: String {
        return String(describing: Self.self)
    }

    var testMethodName: String {
        let nameComponents = [
            method(),
            device(),
            version()
        ].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: "_")

        return nameComponents
    }

    private func device() -> String {
        let deviceName: String
        if let simDevName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] {
            deviceName = simDevName.replacingOccurrences(of: "^.*(iPad|iPhone)", with: "$1", options: .regularExpression)
        } else {
            deviceName = UIDevice.current.model
        }
        return deviceName.replacingOccurrences(of: "\\W+", with: "_", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }

    private func version() -> String {
        return UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
    }

    private func method() -> String {
        let components = name.split(separator: " ")
        guard components.count == 2, let testName = components.last?.replacingOccurrences(of: "]", with: "") else {
            print("Warning: something with test name")
            return name
        }

        return testName
    }
}
