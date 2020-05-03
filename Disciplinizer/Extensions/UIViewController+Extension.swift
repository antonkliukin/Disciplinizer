//
//  UIViewController+Extension.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 25/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

extension UIViewController {
    enum Storyboard: String {
        case alert = "Alert"
        case guide = "Guide"
        case createChallenge = "CreateChallenge"
        case pageNavigation = "PageNavigation"
        case settings = "Settings"
        case history = "History"
        case blocked = "Blocked"
        case currentChallenge = "CurrentChallenge"
        case ad = "Ad"
        case motivationSelection = "MotivationSelection"
        case catStore = "CatStore"
        case timeSelection = "TimeSelection"
        case loading = "Loading"
    }

    class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }

    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }

    class func fromStoryboard(_ storyboard: Storyboard) -> Self {
        let bundle = Bundle(for: self)
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: bundle), identifier: nameOfClass)
    }
}
