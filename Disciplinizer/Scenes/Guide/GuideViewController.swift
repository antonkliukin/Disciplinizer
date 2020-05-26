//
//  GuideViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol GuideViewProtocol: ViewProtocol {
    func updateProgressBar(progress: CGFloat, animated: Bool, completion: (() -> Void)?)
}

extension Notification.Name {
    static let didTapNext = Notification.Name("didTapNext")
}

class GuideViewController: UIViewController, GuideViewProtocol {
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullProgressBarView: UIView!
    
    var presenter: GuidePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDidTapNext), name: .didTapNext, object: nil)
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    @objc private func onDidTapNext() {
        presenter.didTapNext()
    }
    
    func updateProgressBar(progress: CGFloat, animated: Bool, completion: (() -> Void)? = nil) {
        progressBarWidthConstraint.constant = fullProgressBarView.bounds.width * progress
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                completion?()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
}

class GuidePageViewController: UIPageViewController, UIPageViewControllerDataSource, RouterDelegateProtocol {
    
    private var timeSelectionVC: UIViewController?
    private var modeSelectionVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeSelectionVC = Controller.timeSelection(routerDelegate: self)
        modeSelectionVC = Controller.modeSelection(routerDelegate: self)
        
        setViewControllers([timeSelectionVC!], direction: .forward, animated: true, completion: nil)
    }
    
    func didTapNext() {
        NotificationCenter.default.post(name: .didTapNext, object: nil)
        
        if viewControllers?.first == timeSelectionVC {
            setViewControllers([modeSelectionVC!], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
