//
//  Utilities.swift
//  Expense Tracker
//
//  Created by Punit Kumar on 07/05/23.
//

import Foundation
import UIKit

class Utility {
    static func asString(jsonDictionary: [Transaction]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    static func getCurrentMonth() -> String {
        return Date().formatted(.dateTime.year().month(.wide))
    }
    
    static func popToRootView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            findNavigationController(viewController: window.rootViewController)?.popToRootViewController(animated: true)
        }
    }
    
    private static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else { return nil }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
