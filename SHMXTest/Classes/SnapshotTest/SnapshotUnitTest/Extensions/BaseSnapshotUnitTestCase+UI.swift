//
//  BaseSnapshotUnitTestCase+UI.swift
//  SHMXTest
//
//  Created by Максим Шаптала on 29.01.2022.
//

import Foundation
import XCTest

public extension BaseSnapshotUnitTestCase {

    @discardableResult
    func prepareWindow(_ customRootVC: UIViewController? = nil) -> (window: UIWindow,
                                                                    rootViewController: UIViewController) {
        return prepareWindow(true, nil, nil, customRootVC)
    }

    @discardableResult
    func prepareWindow(_ disableAnimations: Bool = true,
                       _ customAnimationSpeed: Float? = nil,
                       _ customFrame: CGRect? = nil,
                       _ customRootVC: UIViewController? = nil) -> (window: UIWindow,
                                                                    rootViewController: UIViewController) {
        if disableAnimations {
            UIView.setAnimationsEnabled(false)

            addTeardownBlock {
                UIView.setAnimationsEnabled(true)
            }
        }

        let rootViewController = customRootVC ?? UIViewController()
        let window = UIWindow(frame: customFrame ?? UIScreen.main.bounds)
        window.layer.speed = customAnimationSpeed ?? 100
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        maintainRunloop()

        return (window, rootViewController)
    }

    func dismiss(_ viewController: UIViewController, timeout: TimeInterval = 5) {
        let expectation = XCTestExpectation(description: "dismiss vc")
        viewController.dismiss(animated: UIView.areAnimationsEnabled) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

    func present(from viewController: UIViewController,
                 to newViewController: UIViewController,
                 timeout: TimeInterval = 5) {
        let expectation = XCTestExpectation(description: "present vc")
        viewController.present(newViewController, animated: UIView.areAnimationsEnabled) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
}
