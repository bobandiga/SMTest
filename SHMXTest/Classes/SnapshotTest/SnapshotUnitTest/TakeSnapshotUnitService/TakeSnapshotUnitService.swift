//
//  TakeSnapshotUnitService.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import Foundation


public protocol TakeSnapshotUnitServiceProtocol {
    func takeSnapshotUnitService(view: UIView) -> UIImage
}


struct TakeSnapshotUnitService: TakeSnapshotUnitServiceProtocol {

    // MARK: Public

    public func takeSnapshotUnitService(view: UIView) -> UIImage {
        return UIGraphicsImageRenderer(bounds: view.bounds).image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
