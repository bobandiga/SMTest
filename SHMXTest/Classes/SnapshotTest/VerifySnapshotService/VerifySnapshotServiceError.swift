//
//  VerifySnapshotServiceError.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 06.03.2022.
//

import Foundation


enum VerifySnapshotServiceError: LocalizedError {
    case noReferenceData
    case noNewData
    case notEqual
}
