//
//  SnapshotUnitFlowManagerError.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 06.03.2022.
//

import Foundation

enum SnapshotUnitFlowManagerError: LocalizedError {
    case fileSuccessfullyCreated(path: String)

    var errorDescription: String? {
        switch self {
            case .fileSuccessfullyCreated(let path):
                return "Successfully save recorded snapshot at: \(path)."
        }
    }

    var failureReason: String? {
        switch self {
            case .fileSuccessfullyCreated(let path):
                return "Record mode is active now."
        }
    }

    var recoverySuggestion: String? {
        switch self {
            case .fileSuccessfullyCreated(let path):
                return "Disable record mode."
        }
    }
}
