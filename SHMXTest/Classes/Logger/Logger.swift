//
//  Logger.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 06.03.2022.
//

import Foundation

protocol LoggerProtocol {
    func consoleLog(error: Error) -> String
}


struct Logger: LoggerProtocol {

    // MARK: Public

    func consoleLog(error: Error) -> String {
        switch error {
            case is LocalizedError:
                return message(localizedError: error as! LocalizedError)

            default:
                return message(error: error)
        }
    }


    // MARK: Private

    private func message(error: Error) -> String {
        let message = ["\n___",
                       "Description: \(error.localizedDescription)"]
            .compactMap { $0 }
            .joined(separator: "\n")
            .appending("\n___")
            
        return message
    }

    private func message(localizedError: LocalizedError) -> String {
        let message = ["\n___",
                       localizedError.errorDescription.map { "Description: \($0)" },
                       localizedError.failureReason.map { "Reason: \($0)" },
                       localizedError.recoverySuggestion.map { "Suggestion: \($0)" }]
            .compactMap { $0 }
            .joined(separator: "\n")
            .appending("\n___")
        return message
    }
}
