//
//  SnapshotFileManager.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import Foundation

public protocol SnapshotFileManagerProtocol {
    init(fileManager: FileManager, snapshotFileExtension: SnapshotFileExtension)

    func getSnapshot(name: String, directory: String) throws -> UIImage
    func saveSnapshot(name: String, directory: String, image: UIImage) throws -> String
    func removeSnapshot(name: String, directory: String) throws -> String
}


struct SnapshotFileManager: SnapshotFileManagerProtocol {

    // MARK: Private properties
    
    private let fileManager: FileManager
    private let snapshotFileExtension: SnapshotFileExtension


    // MARK: Lifecycle

    public init(fileManager: FileManager, snapshotFileExtension: SnapshotFileExtension) {
        self.fileManager = fileManager
        self.snapshotFileExtension = snapshotFileExtension
    }


    // MARK: Public

    public func getSnapshot(name: String, directory: String) throws -> UIImage {
        let snapshotDirectoryURL = URL(fileURLWithPath: directory, isDirectory: true)
        let fullURL = snapshotDirectoryURL.appendingPathComponent(name, isDirectory: false).appendingPathExtension(snapshotFileExtension.rawValue)

        guard fileManager.fileExists(atPath: fullURL.path) else {
            throw SnapshotFileManagerError.fileNotExist(path: fullURL.path)
        }

        guard let data = fileManager.contents(atPath: fullURL.path),
              let image = UIImage(data: data) else {
            throw SnapshotFileManagerError.fileDataNotExist(path: fullURL.path)
        }

        return image
    }

    public func saveSnapshot(name: String, directory: String, image: UIImage) throws -> String {
        let snapshotDirectoryURL = URL(fileURLWithPath: directory, isDirectory: true)
        let fullURL = snapshotDirectoryURL.appendingPathComponent(name, isDirectory: false).appendingPathExtension(snapshotFileExtension.rawValue)
        try fileManager.createDirectory(at: snapshotDirectoryURL, withIntermediateDirectories: true, attributes: [:])
        let fileCreated = fileManager.createFile(atPath: fullURL.path, contents: image.pngData(), attributes: [:])
        guard fileCreated else {
            throw SnapshotFileManagerError.fileNotCreated(path: fullURL.path)
        }

        return fullURL.path
    }

    public func removeSnapshot(name: String, directory: String) throws -> String {
        let snapshotDirectoryURL = URL(fileURLWithPath: directory, isDirectory: true)
        let fullURL = snapshotDirectoryURL.appendingPathComponent(name, isDirectory: false)

        guard fileManager.fileExists(atPath: fullURL.path) else {
            throw SnapshotFileManagerError.fileNotExist(path: fullURL.path)
        }

        try fileManager.removeItem(at: fullURL)
        
        return fullURL.path
    }

}
