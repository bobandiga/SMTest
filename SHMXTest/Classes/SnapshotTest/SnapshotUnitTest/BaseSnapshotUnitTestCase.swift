//
//  BaseSnapshotUnitTestCase.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import XCTest

open class BaseSnapshotUnitTestCase: XCTestCase {

    // MARK: Private properties

    private var baseIsRecording: Bool {
        return ProcessInfo.processInfo.arguments.contains("SNAPSHOTS_RECORD_MODE")
    }

    private var baseSnapshotDir: String {
        return ProcessInfo.processInfo.environment["SNAPSHOTS_REFERENCES"] ?? (NSTemporaryDirectory() + "/Snapshots")
    }

    private var baseSnapshotFailedDir: String {
        return ProcessInfo.processInfo.environment["SNAPSHOTS_FAILED_REFERENCES"] ?? (NSTemporaryDirectory() + "/Snapshots")
    }

    private lazy var logger: LoggerProtocol = Logger()

    private lazy var testName = testMethodName
    private lazy var snapshotDir = baseSnapshotDir.appending("/").appending(testClassName)
    private lazy var failedSnapshotDir = baseSnapshotFailedDir.appending("/").appending(testClassName)

    private lazy var testFlowManager: SnapshotUnitTestFlowManagerProtocol = {
        return  SnapshotUnitTestFlowManager(snapshotFileManager: snapshotFileManager,
                                        assertSnapshot: assertSnapshot,
                                        takeSnapshotUnitService: takeSnapshotUnitService,
                                        takeDifferenceSnapshotService: takeDifferenceSnapshotService,
                                        failedSnapshotDir: failedSnapshotDir,
                                        snapshotDir: snapshotDir,
                                        testName: testName)
    }()


    // MARK: Public properties

    open var snapshotFileManager: SnapshotFileManagerProtocol = SnapshotFileManager(fileManager: .default,
                                                                                    snapshotFileExtension: .png)
    open var assertSnapshot: VerifySnapshotServiceProtocol = VerifySnapshotService()
    open var takeSnapshotUnitService: TakeSnapshotUnitServiceProtocol = TakeSnapshotUnitService()
    open var takeDifferenceSnapshotService: TakeDifferenceSnapshotServiceProtocol = TakeDifferenceSnapshotService()


    // MARK: Public

    open func assertSnapshot(view: UIView,
                             identifier: String? = nil,
                             isRecording: Bool? = nil,
                             delay: TimeInterval? = 0.25,
                             file: StaticString = #file,
                             line: UInt = #line,
                             function: StaticString = #function) {

        if let delay = delay {
            wait(delay)
        }

        if let identifier = identifier {
            testName = [identifier, testMethodName].joined(separator: "_")
        }

        do {
            let isRecording = isRecording ?? baseIsRecording
            if isRecording {
                try testFlowManager.recordSnapshotFlow(view: view)
            } else {
                try testFlowManager.verifySnapshotFlow(view: view)
            }

        } catch {
            let message = logger.consoleLog(error: error)
            XCTFail(message)
        }
    }
}
