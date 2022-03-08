//
//  SnapshotUnitTestFlowManager.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import Foundation

protocol SnapshotUnitTestFlowManagerProtocol {
    init(snapshotFileManager: SnapshotFileManagerProtocol,
         assertSnapshot: VerifySnapshotServiceProtocol,
         takeSnapshotUnitService: TakeSnapshotUnitServiceProtocol,
         takeDifferenceSnapshotService: TakeDifferenceSnapshotServiceProtocol,
         failedSnapshotDir: String,
         snapshotDir: String,
         testName: String
    )

    func recordSnapshotFlow(view: UIView) throws
    func verifySnapshotFlow(view: UIView) throws
}


struct SnapshotUnitTestFlowManager: SnapshotUnitTestFlowManagerProtocol {

    // MARK: Private Data Structures

    private enum FlowReason {
        case record
        case assert
    }

    private let snapshotFileManager: SnapshotFileManagerProtocol
    private let verifySnapshotService: VerifySnapshotServiceProtocol
    private let takeSnapshotUnitService: TakeSnapshotUnitServiceProtocol
    private let takeDifferenceSnapshotService: TakeDifferenceSnapshotServiceProtocol

    private let failedSnapshotDir: String
    private let snapshotDir: String
    private let testName: String


    // MARK: Lifecycle

    init(snapshotFileManager: SnapshotFileManagerProtocol,
         assertSnapshot: VerifySnapshotServiceProtocol,
         takeSnapshotUnitService: TakeSnapshotUnitServiceProtocol,
         takeDifferenceSnapshotService: TakeDifferenceSnapshotServiceProtocol,
         failedSnapshotDir: String,
         snapshotDir: String,
         testName: String
    ) {
        self.snapshotFileManager = snapshotFileManager
        self.verifySnapshotService = assertSnapshot
        self.takeSnapshotUnitService = takeSnapshotUnitService
        self.takeDifferenceSnapshotService = takeDifferenceSnapshotService

        self.failedSnapshotDir = failedSnapshotDir
        self.snapshotDir = snapshotDir
        self.testName = testName
    }


    // MARK: Public

    func recordSnapshotFlow(view: UIView) throws {
        // Make snapshot
        let snapshot = takeSnapshotUnitService.takeSnapshotUnitService(view: view)

        // Save snapshot
        do {
            let path = try snapshotFileManager.saveSnapshot(name: testName,
                                                            directory: snapshotDir,
                                                            image: snapshot)

            throw SnapshotUnitFlowManagerError.fileSuccessfullyCreated(path: path)
        } catch let error as SnapshotFileManagerError {
            throw snapshotFileManagerErrorFlow(error: error, reason: .record)
        } catch {
            throw error
        }
    }

    func verifySnapshotFlow(view: UIView) throws {
        // Get saved snapshot
        let reference = try snapshotFileManager.getSnapshot(name: testName, directory: snapshotDir)

        // Make snapshot
        let new = takeSnapshotUnitService.takeSnapshotUnitService(view: view)

        // Assert snapshot
        do {
            try verifySnapshotService.assertSnapshot(reference: reference, new: new)
        } catch let error as VerifySnapshotServiceError {
            throw VerifySnapshotServiceErrorFlow(error: error,
                                          reference: reference,
                                          failed: new)
        } catch let error as SnapshotFileManagerError {
            throw snapshotFileManagerErrorFlow(error: error, reason: .assert)
        } catch {
            throw error
        }
    }


    // MARK: Private

    private func VerifySnapshotServiceErrorFlow(error: VerifySnapshotServiceError,
                                         reference: UIImage,
                                         failed: UIImage) -> Error  {

        // Check for `notEqual`
        guard error == .notEqual else {
            return error
        }

        // Make difference
        let difference = takeDifferenceSnapshotService.takeDifferenceSnapshotService(reference: reference, failed: failed)

        // Save 3 images: failed, reference, difference
        do {
            try snapshotFileManager.saveSnapshot(name: testName + "_difference",
                                                 directory: failedSnapshotDir,
                                                 image: difference)

            try snapshotFileManager.saveSnapshot(name: testName + "_reference",
                                                 directory: failedSnapshotDir,
                                                 image: reference)

            try snapshotFileManager.saveSnapshot(name: testName + "_failed",
                                                 directory: failedSnapshotDir,
                                                 image: failed)

            return VerifySnapshotServiceError.notEqual
        } catch let error as SnapshotFileManagerError {

            return snapshotFileManagerErrorFlow(error: error, reason: .assert)
        } catch {
            return error
        }
    }

    private func snapshotFileManagerErrorFlow(error: SnapshotFileManagerError, reason: FlowReason) -> Error {
        return error
    }
}
