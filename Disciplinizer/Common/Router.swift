//
//  Router.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func add(_ viewController: UIViewController)
    func add(_ viewController: UIViewController, frame: CGRect?)
    func present(_ viewController: UIViewController)
    ///  - parameter forcePresent: Dismisses another currently presented controller if any.
    func present(_ vc: UIViewController, animated: Bool, forcePresent: Bool, completion: (() -> Void)?)
    func push(_ viewController: UIViewController)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop()
    ///  - parameter toRoot: True - pops all pushed VCs to root VC, false - pops the topmost pushed VC.
    func pop(animated: Bool, toRoot: Bool)
    func dismiss()
    ///  - parameter toRoot: True - dismisses all presented VCs to root VC, false - dismesses the topmost presented VC.
    func dismiss(animated: Bool, completion: (() -> Void)?, toRoot: Bool)
    func remove()
}

class Router: RouterProtocol {
    var initialController: UIViewController

    init(initialController: UIViewController) {
        self.initialController = initialController
    }
    
    func add(_ viewController: UIViewController) {
        let frame = initialController.view.bounds
        add(viewController, frame: frame)
    }
        
    func add(_ viewController: UIViewController, frame: CGRect? = .zero) {
        let frame = initialController.view.bounds
        initialController.add(viewController, frame: frame)
    }

    func present(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }

    func present(_ vc: UIViewController, animated: Bool, forcePresent: Bool = false, completion: (() -> Void)?) {
        if forcePresent {
            initialController.presentedViewController?.dismiss(animated: animated, completion: nil)
        }

        initialController.present(vc, animated: animated, completion: completion)
    }

    func push(_ vc: UIViewController) {
        push(vc, animated: true)
    }

    func push(_ vc: UIViewController, animated: Bool) {
        guard let navController = initialController.navigationController else {
            print("UINavigationController is not found.")
            return
        }

        navController.pushViewController(vc, animated: animated)
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?, toRoot: Bool = false) {
        if toRoot {
            var rootVC = initialController

            while let vc = rootVC.presentingViewController {
                rootVC = vc
            }
            
            if rootVC is RootViewController, let firstChild = rootVC.children.first {
                rootVC = firstChild
            }
            
            rootVC.dismiss(animated: animated, completion: completion)
        } else {
            initialController.dismiss(animated: animated, completion: completion)
        }
    }

    func remove() {
        initialController.remove()
    }
    
    func pop() {
        pop(animated: true, toRoot: false)
    }
    
    func pop(animated: Bool, toRoot: Bool) {
        if let navVC = initialController.navigationController {
            if toRoot {
                navVC.popToRootViewController(animated: animated)
            } else {
                navVC.popViewController(animated: animated)
            }
        }
    }
}

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        child.modalPresentationStyle = .overCurrentContext
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
