//
//  VerifySnapshotService.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import Foundation


public protocol VerifySnapshotServiceProtocol {
    func assertSnapshot(reference: UIImage, new: UIImage) throws
}


struct VerifySnapshotService: VerifySnapshotServiceProtocol {

    // MARK: Public
    
    public func assertSnapshot(reference: UIImage, new: UIImage) throws {
        guard let oldData = reference.pngData() else {
            throw VerifySnapshotServiceError.noReferenceData
        }

        guard let newData = new.pngData() else {
            throw VerifySnapshotServiceError.noNewData
        }

        guard oldData == newData else {
            throw VerifySnapshotServiceError.notEqual
        }
    }
}
