//
//  TakeDifferenceSnapshotService.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 30.01.2022.
//

import Foundation

public protocol TakeDifferenceSnapshotServiceProtocol {
    func takeDifferenceSnapshotService(reference: UIImage, failed: UIImage) -> UIImage
}


struct TakeDifferenceSnapshotService: TakeDifferenceSnapshotServiceProtocol {

    // MARK: Public

    func takeDifferenceSnapshotService(reference: UIImage, failed: UIImage) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: reference.size.width, height: reference.size.height)
        let scale = max(reference.scale, failed.scale)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, scale)
        reference.draw(at: .zero)
        failed.draw(at: .zero, blendMode: .difference, alpha: 1)
        let differenceImage: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return differenceImage
    }
}
