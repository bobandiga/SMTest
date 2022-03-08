//
//  SnapshotFileManagerError.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 06.03.2022.
//

import Foundation

enum SnapshotFileManagerError: LocalizedError {
    case fileNotExist(path: String)
    case fileDataNotExist(path: String)
    case fileNotCreated(path: String)
}
